require File.dirname(__FILE__) + '/../test_helper'

class SwapTest < Test::Unit::TestCase
  fixtures :swaps, :registrations, :users, :swapsets

  def setup
    @swap = swaps(:registration_period)
    @quentin = users(:quentin)
    @aaron = users(:aaron)
  end

  def test_should_register_user
    assert_difference(@swap.users, :count, 1) do
      r = @swap.register @aaron
    end
  end
  
  def test_should_not_register_duplicate
    assert_difference(@swap.users, :count, 0) do
      @swap.register @quentin
    end
  end
  
  def test_should_map_double_correctly
    rt = @swap.register(@aaron, true)
    rf = @swap.register(@quentin)
    assert rt.double?
    assert !rf.double?
  end
  
  def test_should_cancel_registration
    assert_difference(@swap.registrations, :count, -1) do
      @swap.cancel_registration @quentin
    end
  end
  
  def test_should_create_swapsets
    @swap = Swap.create(:deadline => 11.weeks.from_now)
    12.times do |i|
      u = create_user :login => "user#{i}", :email => "email#{i}@test.com", :address => "#{i} Test Street"
      @swap.register u
    end
    assert_equal 12, @swap.users.size
    @swap.make_sets
    assert_equal 2, @swap.swapsets.size
    @one = @swap.swapsets.first
    @two = @swap.swapsets.last
    assert_equal 6, @one.users.size
    assert_equal 6, @two.users.size
    assert ((@one.users.include? User.find(12)) || (@two.users.include? User.find(12)))
    assert !((@one.users.include? @quentin) || (@two.users.include? @quentin))
  end
  
  def test_should_fill_short_set
    @swap = swaps(:registration_period)
    ("A".."F").each { |i| create_user(:login => "user_#{i}", :email => "#{i}@test.com") }
    %w{ A B C }.each do |i|
      @swap.register(User.find_by_login("user_#{i}"))
    end
    %w{ D E F }.each do |i|
      @swap.register(User.find_by_login("user_#{i}"), true)
    end
    @set = @swap.swapsets.create(:name => "set1")
    ("A".."D").each do |i|
      @set.assign User.find_by_login("user_#{i}")
    end
    @swap.initialize_set(@swap.users, SWAPSET_SIZE)
    @extra = @swap.fill_set(@set)
    @set.reload
    # make sure users A-F are in set, and in set only once
    assert_equal 6, @set.users.size
    ("A".."F").each do |i|
      assert @set.users.include? User.find_by_login("user_#{i}")
    end
  end
  
  def test_should_report_failure_to_fill_short_set
     @swap = swaps(:registration_period)
      ("A".."F").each { |i| create_user(:login => "user_#{i}", :email => "#{i}@test.com") }
      %w{ C D E }.each do |i|
        @swap.register(User.find_by_login("user_#{i}"))
      end
      %w{ A B F }.each do |i|
        @swap.register(User.find_by_login("user_#{i}"), :double => true)
      end
      @set = @swap.swapsets.create(:name => "set1")
      ("A".."D").each do |i|
        @set.assign User.find_by_login("user_#{i}")
      end
      assert_raises RuntimeError do
        @swap.fill_set(@set)
      end
  end
  
  # find simple (optimum score = 0) solutions to short set
  def test_should_find_optimum_fill_simple
    @swap = swaps(:registration_period)
    @old = swaps(:expired)
    ("A".."H").each { |i| create_user(:login => "user_#{i}", :email => "#{i}@test.com") }
    @old_set_1 = @old.swapsets.create :name => "Old Set 1"
    @old_set_2 = @old.swapsets.create :name => "Old Set 2"
    %w{ A E }.each { |i| @old_set_1.assign User.find_by_login "user_#{i}" }
    %w{ B F }.each { |i| @old_set_2.assign User.find_by_login "user_#{i}" }
    @set = @swap.swapsets.create :name => "New Set"
    %w{ A B C D }.each do |i|
      user =  User.find_by_login "user_#{i}"
      @swap.register user
      @set.assign user
    end
    %w{ E F G H }.each do |i|
      user =  User.find_by_login "user_#{i}"
      @swap.register(user, true) # register as double
    end
    @swap.initialize_set(@swap.users, SWAPSET_SIZE, Swapset.find(:all).map {|set| set.users})
    @swap.fill_set(@set)
    @set.reload
    assert_equal 6, @set.users.size
    %w{ A B C D G H}.each do |i|
      assert @set.users.include? User.find_by_login "user_#{i}"
    end
    %w{ E F }.each do |i|
      assert !(@set.users.include? User.find_by_login "user_#{i}")
    end
  end
  
  # find complex (optimum score > 0) solutions to short set
  def test_should_find_optimum_fill_complex
    @swap = swaps(:registration_period)
    @old = swaps(:expired)
    ("A".."H").each { |i| create_user(:login => "user_#{i}", :email => "#{i}@test.com") }
    @old_set_1 = @old.swapsets.create :name => "Old Set 1"
    @old_set_2 = @old.swapsets.create :name => "Old Set 2"
    @old_set_3 = @old.swapsets.create :name => "Old Set 3"
    @old_set_4 = @old.swapsets.create :name => "Old Set 4"
    @set = @swap.swapsets.create :name => "New Set"
    # old sets are constructed so that [G,H] is the best possible solution
    %w{ A G }.each { |i| @old_set_1.assign User.find_by_login "user_#{i}" }
    %w{ B H }.each { |i| @old_set_2.assign User.find_by_login "user_#{i}" }
    %w{ A C E }.each { |i| @old_set_3.assign User.find_by_login "user_#{i}" }
    %w{ B D F }.each { |i| @old_set_1.assign User.find_by_login "user_#{i}" }
    %w{ A B C D }.each do |i|
      user =  User.find_by_login "user_#{i}"
      @swap.register user
      @set.assign user
    end
     %w{ E F G H }.each do |i|
      user =  User.find_by_login "user_#{i}"
      @swap.register(user, true) # register as double
    end
    @swap.initialize_set(@swap.users, SWAPSET_SIZE, Swapset.find(:all).map {|set| set.users})
    @swap.fill_set(@set)
    @set.reload
    assert_equal 6, @set.users.size
    %w{ A B C D G H}.each do |i|
      assert @set.users.include? User.find_by_login "user_#{i}"
    end
    %w{ E F }.each do |i|
      assert !(@set.users.include? User.find_by_login "user_#{i}")
    end
  end
  
  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire', :address => 'Quire Ave.' }.merge(options))
    end
end
