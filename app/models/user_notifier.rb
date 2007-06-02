class UserNotifier < ActionMailer::ARMailer
  
  default_url_options[:host] = 'www.example.com'
  
  def signup_notification(user)
    setup_email(user)
    @subject    += "Welcome to #{PROJECT_NAME}!"
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
  
  def assignment_notification(user)
    setup_email(user)
    @subject += 'Your swap assignment is ready'
    @body[:url] = login_url
    @body[:deadline] = Swap.current.deadline.to_s(:small)
  end
  
  def registration_reminder(user)
    setup_email(user)
    @subject += 'Last week to complete your swap surveys'
    @body[:url] = login_url
    @body[:deadline] = Swap.current.registration_deadline.to_s(:small)
  end
  
  def mailing_reminder(user)
    setup_email(user)
    @subject += 'Last week to mail your mixes'
    @body[:url] = login_url
    @body[:deadline] = Swap.current.deadline.to_s(:small)
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
