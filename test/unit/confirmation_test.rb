require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps, :swapsets

  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @set = swapsets(:alligator)
    @assign = @set.assign @aaron
  end

  def test_should_create
    
    assert !(@aaron.confirmed_for? @assign.swap)
    assert_difference(Confirmation, :count, 1) do
      Confirmation.create(:from => @quentin, :assignment => @assign)
    end
    assert @aaron.confirmed_for? @assign.swap
  end
  
  def test_should_destroy
    c = Confirmation.create(:from => @quentin, :assignment => @assign)
    assert_difference(Confirmation, :count, -1) do
      c.destroy
    end
    assert !(@aaron.confirmed_for? @assign.swap)
  end
end
