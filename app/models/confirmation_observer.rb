class ConfirmationObserver < ActiveRecord::Observer
  def before_create(confirmation)
    @user = confirmation.to
    5.times { @user.give_invite } unless @user.confirmed_for?(confirmation.swap)
  end
  
  def after_destroy(confirmation)
    confirmation.assignment.favorites.find_by_from_user(confirmation.user.id).destroy
  rescue
  end
end
