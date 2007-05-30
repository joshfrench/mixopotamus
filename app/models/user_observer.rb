class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Swap.current.register(user) if Swap.current && Swap.current.open?
    give_freebies(user)
    UserNotifier.deliver_signup_notification(user)
  end
  
  def after_save(user)
    UserNotifier.deliver_forgot_password(user) if user.recently_forgot_password?
    UserNotifier.deliver_reset_password(user) if user.recently_reset_password?
  end
  
  protected
  def give_freebies(user)
    list = File.read(File.expand_path(RAILS_ROOT + "/lib/freebies")).map &:chomp
    5.times { user.give_invite } if list.include? user.email
  end
end
