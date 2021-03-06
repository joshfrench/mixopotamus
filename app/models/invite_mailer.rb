class InviteMailer < ActionMailer::ARMailer
    
  def invite_for(invite)
    @recipients     = "#{invite.to_email}"
    @from           = ADMIN_EMAIL
    @subject        = "#{invite.user.login} has sent you a Mixopotamus invitation"
    @sent_on        = Time.now
    @body[:invite]  = invite
    @body[:url]     = redeem_invite_url(invite.uuid)
  end
  
end
