require File.dirname(__FILE__) + '/../test_helper'

class AssignmentTest < Test::Unit::TestCase
  fixtures :assignments, :users, :swapsets, :swaps, :registrations
  
  def setup
    @quentin = users(:quentin)
    @aaron = users(:aaron)
    @alligator = swapsets(:alligator)
  end

  def test_should_assign_user
    assert_difference(Assignment, :count, 1) do
      Assignment.create(:swapset_id => @alligator.id, :user_id => @aaron.id)
    end
  end
  
  def test_should_flunk_duplicates
    assert_difference(Assignment, :count, 0) do
      # have to scope assignment through alligator
      # because it searches through it for the swap.doubles
      a = @alligator.assignments.create(:user_id => @quentin.id)
    end
  end
  
  def test_should_pass_doubles
    assert @quentin.registrations.first.update_attribute(:double, true)
  end
  
  def test_should_add_assignment
    flunk
  end
end
