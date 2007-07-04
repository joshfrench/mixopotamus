require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationObserverTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps, :swapsets, :favorites
  
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
  
  def test_destroy_favorite_with_confirmation
    @confirmation = confirmations(:aaron_to_quentin)
    @aaron = users(:aaron)
    assert @aaron.favorited?(@confirmation.assignment)
    assert_difference Favorite, :count, -1 do
      @confirmation.destroy
    end
    assert !(@aaron.reload.favorited? @confirmation.assignment)
  end
  
  def test_destroy_confirmation_without_favorite
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    swapsets(:alligator).assign users(:aaron)
    @quentin.confirm @aaron.assignments.first
    @confirmation = @quentin.confirmations.first
    assert_difference Confirmation, :count, -1 do
      @confirmation.destroy
    end
  end
  
end
