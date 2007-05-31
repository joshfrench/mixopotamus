require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationObserverTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps, :swapsets
  
  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @assign = assignments(:one)
  end
  
  def test_give_invites_on_first_confirm
    confirmations(:aaron_to_quentin).destroy # clean slate
    assert_difference(@quentin, :invite_count, 5) do
      Confirmation.create(:from => @aaron, :assignment => @assign)
      @quentin.reload
    end
  end
  
  def test_dont_give_invites_on_subsequent_confirm
    assert_no_difference(@quentin, :invite_count) do
      Confirmation.create(:from => @aaron, :assignment => @assign)
      @quentin.reload
    end
  end
  
end
