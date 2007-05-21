module RegistrationsHelper
  def show_registration_for(user)
    render :partial => (Swap.current.registration_deadline < Time.now) ? "closed" : "cancel"
  end
  
  def registration_form_for(user)
    render :partial => current_user.ok_to_play? ? "new" : "burned"
  end
end
