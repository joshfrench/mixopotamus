require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps, :swapsets

  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @set = swapsets(:alligator)
    @swap = @set.swap
    @set.assign @aaron
  end

  def test_should_create
    assert !(@aaron.confirmed_for? @swap)
    @assign = Assignment.find_by_user_id(@aaron.id)
    assert_difference(Confirmation, :count, 1) do
      @quentin.confirm(@assign)
    end
    @aaron.reload
    @swap.reload
    assert @aaron.confirmed_for?(@swap)
  end
  
  def test_should_destroy
    c = confirmations(:aaron_to_quentin)
    assert @quentin.confirmed_for?(@swap)
    assert_difference(Confirmation, :count, -1) do
      c.destroy
    end
    @quentin.reload
    assert !(@quentin.confirmed_for? @swap)
  end
end
