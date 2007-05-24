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
  
  def test_should_pass_doubles
    assert @quentin.registrations.first.update_attribute(:double, true)
  end
  
end
