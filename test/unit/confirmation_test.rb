require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps, :swapsets

  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @set = swapsets(:alligator)
    @set.assign @aaron
  end

  def test_should_create
    
    assert !(@aaron.confirmed_for? @set.swap)
    assert_difference(Confirmation, :count, 1) do
      Confirmation.create(:from => @quentin, :to => @aaron, :swapset => @set)
    end
    assert @aaron.confirmed_for? @set.swap
  end
  
  def test_should_destroy
    c = confirmations(:aaron_to_quentin)
    assert_difference(Confirmation, :count, -1) do
      c.destroy
    end
    assert !(@quentin.confirmed_for? @set.swap)
  end
end
