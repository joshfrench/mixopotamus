module InvitesHelper
  def do_invite_form_for(user)
    user.invite_count > 0 ? (render :partial => "form") : content_tag('p', ibm("You don't have any invites right now. You'll get more at the end of this swap."))
  end
end
