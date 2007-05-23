class AccountController < ApplicationController

  before_filter :login_required, :only => [:show, :logout]

  # say something nice, you goof!  something sweet.
  def show
    redirect_to('/') unless logged_in? || User.count > 0
    @user = current_user
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      redirect_back_or_default(:controller => "account", :action => "show")
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

end
