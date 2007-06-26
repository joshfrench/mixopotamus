require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :users, :swaps, :swapsets, :favorites, :assignments
  
  def test_should_give_invite
    @quentin = users(:quentin)
    assert_difference(@quentin, :invite_count, 1) do
      @quentin.give_invite
    end
  end
  
  def test_find_swapset_by_position
    assert_equal swapsets(:alligator), users(:quentin).find_swapset_by_position(1)
  end
  
  def test_registered_for?
    @user = users(:quentin)
    assert @user.registered_for? swaps(:registration_period)
    assert !(@user.registered_for? swaps(:expired))
  end
  
  def test_should_decrement_successful_invite
    @aaron = users(:aaron)
    assert_difference(Invite, :count, 1) do
      @invite = @aaron.create_invite 'test@foo.com', "Foo"
    end
    assert_difference(@aaron, :invite_count, -1) do
      @aaron.send_invite @invite
    end
  end
  
  def test_should_not_decrement_bad_invite
    @aaron = users(:aaron)
    assert_no_difference(@aaron, :invite_count) do
      i = @aaron.create_invite 'test@foo', "Foo"
    end
    assert_no_difference(Invite, :count) do
      i = @aaron.create_invite 'test@foo', "Foo"
    end
  end
  
  def test_should_not_allow_zero_invites_to_send
    @quentin = users(:quentin)
    assert_raises RuntimeError do
      i = @quentin.create_invite 'test@foo.com', "Foo"
    end
    assert_equal 0, @quentin.invite_count
  end
  
  def test_forgot_password
    @user = users(:aaron)
    @user.forgot_password
    @user.save
    assert_not_nil @user.reset
  end
  
end
