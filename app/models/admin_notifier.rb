class AdminNotifier < ActionMailer::ARMailer
  
  def new_users
    @recipients       = "josh@vitamin-j.com"
    @from             = ADMIN_EMAIL
    @subject          = "[#{PROJECT_NAME}] New Users"
    @sent_on          = Time.now
    @body[:new_users] = User.recent_signups
  end
end
