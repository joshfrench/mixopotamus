class InviteObserver < ActiveRecord::Observer
  def after_save(invite)
    InviteMailer.deliver_invite_for(invite) if invite.recently_delivered?
  end
end
