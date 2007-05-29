class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Welcome'
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = ADMIN_EMAIL
    @subject     = "[#{PROJECT_NAME}] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
