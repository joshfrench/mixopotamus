class UserNotifier < ActionMailer::Base
  
  default_url_options[:host] = 'www.example.com'
  
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Welcome'
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += 'Password change requested'
    @body[:url]  = reset_url(:reset => user.reset)
  end

  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been reset'
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
