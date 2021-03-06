require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  
  fixtures :users, :swaps, :invites

  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    ActionMailer::Base.deliveries = []
    @emails = ActionMailer::Base.deliveries 
  end
  
  def test_markup
    login_as :quentin
    get :show
    assert_valid_markup
  end

  def test_should_login_and_redirect
    post :login, :email => 'quentin@example.com', :password => 'test'
    assert session[:user]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :email => 'quentin@example.com', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
    assert_valid_markup
  end

  def test_should_allow_signup
    deliveries = ActionMailer::Base.deliveries.size
    assert_difference User, :count do
      create_user
      assert_response :redirect
    end
    assert_equal deliveries+1, ActionMailer::Base.deliveries.size
  end

  def test_should_require_login_on_signup
    assert_no_difference User, :count do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
      assert_valid_markup
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference User, :count do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference User, :count do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference User, :count do
      create_user(:email => nil)
      assert assigns(:user)
      assert assigns(:user).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:user]
    assert_response :success
    assert_template "account/login"
  end

  def test_should_remember_me
    post :login, :email => 'quentin@example.com', :password => 'test', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

#   REMOVED; APP ALWAYS REMEMBERS LIKE AN ELEPHANT
#  def test_should_not_remember_me
#   post :login, :email => 'quentin@example.com', :password => 'test', :remember_me => "0"
#    assert_nil @response.cookies["auth_token"]
#  end
  
  def test_should_delete_token_on_logout
    login_as :quentin
    get :logout
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    users(:quentin).remember_me
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :show
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    users(:quentin).remember_me
    users(:quentin).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:quentin)
    get :show
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    users(:quentin).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :show
    assert !@controller.send(:logged_in?)
  end
  
  def test_should_populate_email_if_given
    email = 'test@foobar.com'
    get :signup, {:email => email}, :invite => invites(:open)
    assert_tag :tag => "input",
               :attributes => { :value => /#{email}/ }
  end
  
  def test_should_forget_password
    assert_difference(@emails, :size, 1) do
      post :forgot_password, :email => 'quentin@example.com'
      assert_response :redirect
      assert flash.has_key?(:confirm), "A password reset link was sent to your email address."
    end
    assert_match /Password change requested/, @emails.first.subject
  end

  def test_should_not_forget_password
    post :forgot_password, :email => 'invalid@email'
    assert_response :success
    assert flash.has_key?(:error), "No user was found with that email address." 
    assert_equal 0, @emails.length
  end
  
  def test_should_reset_password
    @quentin = users(:quentin)
    pass = 'newpassword'
    reset = @quentin.forgot_password
    @quentin.save
    post :reset_password, { :reset => reset, :password => pass, :password_confirmation => pass }
    @quentin.reload
    assert_equal @quentin.encrypt(pass), @quentin.crypted_password
    assert_equal 2, @emails.length #both forgot & reset are sent
    assert_match /Your password has been reset/, @emails.last.subject
  end

  protected
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
