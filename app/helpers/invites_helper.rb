module InvitesHelper
  def do_invite_form_for(user)
    render :partial => user.invite_count > 0 ? "form" : "no_invites"
  end
end
