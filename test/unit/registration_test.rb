require File.dirname(__FILE__) + '/../test_helper'

class RegistrationTest < Test::Unit::TestCase
  fixtures :registrations, :users, :swaps, :swapsets
  
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
  
  def test_should_accept_past_participant
    @new_swap = Swap.create(:deadline => 12.weeks.from_now)
    Confirmation.create(:from => @aaron, :to => @quentin, :swapset => swapsets(:alligator))
    assert_difference(Registration, :count, 1) do
      r = Registration.create(:user_id => @quentin.id, :swap_id => @new_swap.id, :double => false)
    end
  end
  
end
