require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @quentin = users(:quentin)
  end

  def test_markup
    login_as :quentin
    get :edit
    assert_valid_markup
  end
  
  def test_edit
    login_as :quentin
    new_name = "Seymour Butts"
    new_address = "123 Anytown Lane, USA 12345"
    new_email = 'foo@bar.com'
    xhr :post, :edit, :user => { :login => new_name, :address => new_address, :email => 'new_email' }
    assert_response :success
    @quentin.reload
    assert_equal new_name, @quentin.login
    assert_equal new_address, @quentin.address
    assert_equal new_email, @quentin.email
  end
end
