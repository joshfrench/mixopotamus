require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :users, :swaps, :swapsets, :favorites, :assignments
  
  def test_should_give_invite
    @quentin = users(:quentin)
    assert_difference(@quentin, :invite_count, 1) do
      @quentin.give_invite
    end
  end
  
  def test_should_decrement_successful_invite
    @aaron = users(:aaron)
    assert_difference(Invite, :count, 1) do
      @invite = @aaron.create_invite 'test@foo.com'
    end
    assert_difference(@aaron, :invite_count, -1) do
      @aaron.send_invite @invite
    end
  end
  
  def test_should_not_decrement_bad_invite
    @aaron = users(:aaron)
    assert_no_difference(@aaron, :invite_count) do
      i = @aaron.create_invite 'test@foo'
    end
    assert_no_difference(Invite, :count) do
      i = @aaron.create_invite 'test@foo'
    end
  end

  def test_should_detect_favorites
    @set = swapsets(:alligator)
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @set.assign @aaron
    assert @quentin.favorited(@aaron, @set).nil?
    assert @quentin.favorite(@aaron, @set)
    @quentin.reload
    @set.reload
    assert !(@quentin.favorited(@aaron, @set).nil?)
  end
  
  def test_should_not_allow_zero_invites_to_send
    @quentin = users(:quentin)
    assert_raises RuntimeError do
      i = @quentin.create_invite('test@foo.com')
    end
    assert_equal 0, @quentin.invite_count
  end
  
end
