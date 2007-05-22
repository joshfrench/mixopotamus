require File.dirname(__FILE__) + '/../test_helper'

class RegistrationTest < Test::Unit::TestCase
  fixtures :registrations, :users, :swaps, :assignments
  
  def setup
    @swap = swaps(:registration_period)
    @quentin = users(:quentin)
    @aaron = users(:aaron)
  end
  
  def test_should_add_user
    assert_difference(Registration, :count, 1) do
      Registration.create(:user_id => @aaron.id, :swap_id => @swap.id, :double => false)
    end
  end
   
  def test_should_flunk_duplicate_user
    assert_difference(Registration, :count, 0) do
      Registration.create(:user_id => @quentin.id, :swap_id => @swap.id, :double => false)
    end
  end
  
  def test_should_flunk_expired_swaps
    @closed = swaps(:mix_period)
    
    assert_difference(Registration, :count, 0) do
      Registration.create(:user_id => @aaron.id, :swap_id => @closed.id, :double => false)
    end
  end
  
  def test_should_flunk_invalid_swap
    assert_difference(Registration, :count, 0) do
      r = Registration.create(:user_id => @aaron.id, :swap_id => 99999, :double => false)
      assert r.errors.on :swap
    end
  end
  
  def test_should_flunk_moocher
    @swap = Swap.create(:deadline => 12.weeks.from_now)
    assert_no_difference(Registration, :count) do
      r = Registration.create(:user_id => @quentin.id, :swap_id => @swap.id, :double => false)
      assert r.errors.on :user
    end
  end
  
  def test_should_accept_past_participant
    @new_swap = Swap.create(:deadline => 12.weeks.from_now)
    Confirmation.create(:from => @aaron, :assignment => assignments(:one))
    assert_difference(Registration, :count, 1) do
      r = Registration.create(:user_id => @quentin.id, :swap_id => @new_swap.id, :double => false)
    end
  end
  
end
