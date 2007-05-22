module InvitesHelper
  def do_invite_form_for(user)
    render :partial => user.invite_count > 0 ? "form" : "no_invites"
  end
  
  def do_form_with_last_invite_message(user)
    render :partial => user.invite_count > 0 ? "form" : "last_invite"
  end
end
