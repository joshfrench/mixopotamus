require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :users, :swaps
  
  def test_should_give_invite
    @quentin = users(:quentin)
    assert_difference(@quentin, :invites, 1) do
      @quentin.give_invite
    end
  end
  
  def test_should_decrement_successful_invite
    @aaron = users(:aaron)
    assert_difference(@aaron, :invites, -1) do
      @aaron.invite 'test@foo.com'
    end
  end
  
  def test_should_not_decrement_bad_invite
    @aaron = users(:aaron)
    assert_no_difference(@aaron, :invites) do
      i = @aaron.invite 'test@foo'
    end
  end
  
  def test_should_not_allow_zero_invites_to_send
    @quentin = users(:quentin)
    assert_throws :out_of_invites do
      @quentin.invite('test@foo.com')
    end
    assert_equal 0, @quentin.invites
  end
  
  def test_should_add_confirmation
    @quentin = users(:quentin)
    @swap = swaps(:registration_period)
    assert !(@quentin.confirmed_for? @swap)
    @quentin.confirm_for @swap
    assert @quentin.confirmed_for? @swap
  end
  
  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire', :address => 'Quire Ave.' }.merge(options))
    end
end
