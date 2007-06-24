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
    @user = User.find(params[:user_id])
    @invite = @user.create_invite(params[:invite][:to], params[:invite][:message])
    respond_to do |format|
      format.js do
        if @invite.valid?
          if @invite.is_unique?
            @user.send_invite(@invite)
            flash.now[:confirm] = "Invitation sent to #{@invite.to_email}!"
            make_new_invite
          else
            flash.now[:error] = "Someone already sent an invite to #{@invite.to_email}. Send anyway?"
            render :action => "confirm"
          end
        else
          flash.now[:had_error] = true
        end 
      end
    end
  end
  
  def confirm
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.js do
        @invite = @user.invites.find_by_id(params[:id])
        @user.send_invite @invite
        flash.now[:confirm] = "Invitation sent to #{@invite.to_email}!"
        make_new_invite
        render :action => "create" 
      end
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.js do
        @user.invites.find_by_id(params[:id]).destroy
        flash.now[:error] = "Invite cancelled."
        make_new_invite 
      end
    end
  end
  
  def new
    make_new_invite
  end
  
  def authorized?
    %w{ create confirm destroy }.include?(action_name) ? current_user==User.find(params[:user_id]) : true
  end
  
  protected
  def make_new_invite
        @default_email = 'myfriend@mixopotamus.com'
        @default_message = "Hi friend,

Have you ever received a great mix from a friend? How about a total stranger? You can get both if you join me at Mixopotamus, a simple mix swapping project. You'll exchange an original mix CD with 5 other people, selected at random.

What will your mix say about you? And to whom? Who knows. But I know you've got great taste in music--why not share it with others and discover some great new stuff while you're at it?

Happy mixing!
#{current_user.first_name}"
        @invite = Invite.new :to => @default_email,
                             :message => @default_message
  end
  
end