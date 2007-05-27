class AccountController < ApplicationController

  before_filter :login_required, :only => [:show, :logout]

  # say something nice, you goof!  something sweet.
  def show
    redirect_to(default_url) unless logged_in? || User.count > 0
    @user = current_user
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      self.current_user.remember_me
      cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      redirect_to default_url
    else
      flash.now[:error] = 'Incorrect email or password.'
    end
  end

  def signup
    (redirect_to default_url and return) unless session[:invite]
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    session[:invite].accept if session[:invite]
    session[:invite] = nil
    flash[:welcome] = true
    self.current_user = @user
    redirect_to default_url
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:error] = "You have been logged out."
    redirect_to default_url
  end

end
