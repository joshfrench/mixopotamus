class InvitesController < ApplicationController
  before_filter :login_required, :except => :show
  
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
  
  def create
    @invite = current_user.create_invite(params[:invite][:to])
    if @invite.valid?
      if @invite.is_unique?
        current_user.send_invite(@invite)
        flash.now[:confirm] = "Invite sent to #{@invite.to_email}!"
      else
        flash.now[:error] = "Someone already sent an invite to #{@invite.to_email}.<br/>Send anyway?"
        render :action => "confirm"
      end
    end
  end
  
  def confirm
    @invite = current_user.invites.find_by_id(params[:id])
    current_user.send_invite @invite
    flash.now[:confirm] = "Invite sent to #{@invite.to_email}!"
    render :action => "create"
  end

  def destroy
    current_user.invites.find_by_id(params[:id]).destroy
    flash.now[:error] = "Invite cancelled."
    @invite = Invite.new
  end
  
  def new
    @invite = Invite.new
  end
  
end