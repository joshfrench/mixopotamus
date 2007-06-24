module InvitesHelper  
  def do_invite_form_for(user)
    render :partial => user.invite_count > 0 ? "form" : "no_invites"
  end
  
  def do_form_with_last_invite_message(user)
    render :partial => user.invite_count > 0 ? "form" : "last_invite"
  end
  
  def get_strings_for_no_invites
    @strings = current_user.swaps.empty? ? %w( some first ) : %w( more next )
  end
  
  def get_string_for_invites_left
    sprintf("You have #{pluralize current_user.reload.invite_count, 'invite'} left. %s", 1 == current_user.invite_count ? 'Why not send it now?' : "Go ahead and send one!")
  end
  
end
