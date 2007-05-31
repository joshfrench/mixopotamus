class ConfirmationObserver < ActiveRecord::Observer
  def before_create(confirmation)
    @user = confirmation.to
    5.times { @user.give_invite } unless @user.confirmed_for?(confirmation.swap)
  end
end
