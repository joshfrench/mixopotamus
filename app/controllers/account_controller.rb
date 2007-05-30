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
    flash[:welcome] = true
    self.current_user = @user
    session[:invite].accept(current_user)
    session[:invite] = nil
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
  
  def forgot_password
    return unless request.post?
    if @user = User.find_by_email(params[:email])
      @user.forgot_password
      @user.save
      flash[:confirm] = "A password reset link was sent to your email address."
      redirect_to default_url
    else
      flash[:error] = "No user was found with that email address."
    end
  end
  
  def reset_password
    if @user = User.find_by_reset(params[:reset])
      return unless request.post?
      if params[:password] == params[:password_confirmation]
        self.current_user = @user
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        @user.reset_password
        if @user.save
          flash[:global] = "Your password has been reset."
          redirect_to default_url
        end
      end
      flash.now[:error] = "Password does not match confirmation."
    else
      redirect_to default_url
    end
  end

end
