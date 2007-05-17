class InvitesController < RestController
  undef_method :index, :destroy, :update, :edit
  
  def show
    if @invite = Invite.find_by_uuid(params[:id])
      begin
        redirect_to :controller => "account", :action => "signup", :email => @invite.to_email if @invite.accept
      rescue
        flash[:error] = "Sorry, that invite has already been used by someone."
      end
    else
      flash[:error] = "Sorry, that's not a valid invite code. Please check the link you received and try again."
    end
  end
  
end