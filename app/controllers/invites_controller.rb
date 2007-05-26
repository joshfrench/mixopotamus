class InvitesController < ApplicationController
  before_filter :login_required, :except => :show
  
  def show
    @invite = Invite.find_by_uuid(params[:id])
    if @invite.open?
      session[:invite] = @invite
      redirect_to(:controller => "account", :action => "signup", :email => @invite.to_email)
      return
    elsif @invite.accepted?
      flash.now[:error] = "Sorry, that invite has already been used by someone."
    else
      raise "Got an invite with some other problem."
    end
    render :layout => "application"
  rescue
    flash.now[:error] = "Sorry, that's not a valid invite code. Please check the link you received and try again."
    render :layout => "application"
  end
  
  def create
    respond_to do |format|
      format.js do
        @invite = current_user.create_invite(params[:invite][:to])
        if @invite.valid?
          if @invite.is_unique?
            current_user.send_invite(@invite)
            flash.now[:confirm] = "Invitation sent to #{@invite.to_email}!"
          else
            flash.now[:error] = "Someone already sent an invite to #{@invite.to_email}. Send anyway?"
            render :action => "confirm"
          end
        end 
      end
    end
  end
  
  def confirm
    respond_to do |format|
      format.js do
        @invite = current_user.invites.find_by_id(params[:id])
        current_user.send_invite @invite
        flash.now[:confirm] = "Invitation sent to #{@invite.to_email}!"
        render :action => "create" 
      end
    end
  end

  def destroy
    respond_to do |format|
      format.js do
        current_user.invites.find_by_id(params[:id]).destroy
        flash.now[:error] = "Invite cancelled."
        @invite = Invite.new 
      end
    end
  end
  
  def new
    @invite = Invite.new
  end
  
end