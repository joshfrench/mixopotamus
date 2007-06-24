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
    string = Array.new.push ibm("You have #{pluralize current_user.reload.invite_count, 'invite'} left. Why not ")
    string << (1 == current_user.invite_count ? ibm('send it now') : ibm('send one now'))
    string
  end
  
end
