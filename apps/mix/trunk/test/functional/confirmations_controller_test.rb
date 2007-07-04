require File.dirname(__FILE__) + '/../test_helper'
require 'confirmations_controller'

# Re-raise errors caught by the controller.
class ConfirmationsController; def rescue_action(e) raise e end; end

class ConfirmationsControllerTest < Test::Unit::TestCase
  
  fixtures :users, :assignments, :swapsets, :swaps, :registrations, :confirmations
  
  def setup
    @controller = ConfirmationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @aaron = users(:aaron)
    @quentin = users(:quentin)
    @set = swapsets(:alligator)
    @set.assign @aaron
  end

  def test_create
    login_as :quentin
    assign = Assignment.find_by_user_id(@aaron.id)
    assert_difference(Confirmation, :count, 1) do
      xhr :post, :create, { :user_id => @quentin.id, :assign => assign.id }
    end
    assert_response :success
    assert /mail_on.png/.match(@response.body)
  end
  
  def test_destroy
    login_as :aaron
    assert_difference(Confirmation, :count, -1) do
      xhr :delete, :destroy, { :user_id => @aaron.id, :id => confirmations(:aaron_to_quentin) }
    end
    assert_response :success
    assert /mail_off.png/.match(@response.body)
  end
  
  def test_unauthorized_create
    login_as :quentin
    assign = assignments(:one)
    assert_no_difference(Confirmation, :count) do
      xhr :post, :create, { :user_id => @aaron.id, :assign => assign.id }
    end
  end
  
  def test_unauthorized_destroy
    login_as :quentin
    assert_no_difference(Confirmation, :count) do
      xhr :delete, :destroy, { :user_id => @aaron.id, :id => confirmations(:aaron_to_quentin) }
    end
  end
end
