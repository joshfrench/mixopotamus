module RegistrationsHelper
  def show_registration_for(user)
    render :partial => (Swap.current.registration_deadline < Time.now) ? "closed" : "cancel"
  end
  
  def registration_form_for(user)
    if Swap.current.registration_deadline < Time.now
      render :partial => "closed"
    else
      render :partial => current_user.ok_to_play? ? "signup" : "burned"
    end
  end
  
end
