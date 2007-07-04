require File.dirname(__FILE__) + '/../test_helper'

class AssignmentObserverTest < Test::Unit::TestCase
  fixtures :assignments, :users, :swapsets, :swaps

  def setup
    ActionMailer::Base.deliveries = []
    @emails = ActionMailer::Base.deliveries
  end
  
  def test_send_assignment_notification
    assert_difference(@emails, :size, 1) do
      swapsets(:alligator).assign users(:aaron)
    end
  end
end
