class AssignmentObserver < ActiveRecord::Observer
  def after_create(assignment)
    UserNotifier.deliver_assignment_notification(assignment.user)
  end
end
