require File.dirname(__FILE__) + '/../test_helper'

class ConfirmationTest < Test::Unit::TestCase
  fixtures :confirmations, :users, :assignments, :swaps

  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @assign = assignments(:one)
  end

  def test_should_create
    assert !(@quentin.confirmed_for? @assign.swap)
    assert_difference(Confirmation, :count, 1) do
      Confirmation.create(:from => @aaron, :assignment => @assign)
    end
    assert @quentin.confirmed_for? @assign.swap
  end
  
  def test_should_destroy
    c = Confirmation.create(:from => @aaron, :assignment => @assign)
    assert_difference(Confirmation, :count, -1) do
      c.destroy
    end
    assert !(@quentin.confirmed_for? @assign.swap)
  end
end
