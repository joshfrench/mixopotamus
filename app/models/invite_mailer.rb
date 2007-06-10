class InviteMailer < ActionMailer::ARMailer
  
  default_url_options[:host] = 'www.example.com'
  
  def invite_for(invite)
    @recipients     = "#{invite.to_email}"
    @from           = ADMIN_EMAIL
    @subject        = "#{invite.user.login} likes your taste in music!"
    @sent_on        = Time.now
    @body[:invite]  = invite
    @body[:url]     = redeem_invite_url(invite.uuid)
  end
  
end
