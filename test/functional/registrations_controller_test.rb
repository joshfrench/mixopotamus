require File.dirname(__FILE__) + '/../test_helper'
require 'registrations_controller'

# Re-raise errors caught by the controller.
class RegistrationsController; def rescue_action(e) raise e end; end

class RegistrationsControllerTest < Test::Unit::TestCase
  
  fixtures :users, :swaps, :swapsets, :registrations, :assignments, :confirmations
  
  def setup
    @controller = RegistrationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_burned
    login_as :quentin
    # create some new swaps so quentin will fail ok_to_play?
    @swap1 = Swap.create(:deadline => 8.weeks.from_now)
    @swap1.register users(:quentin)
    @swap2 = Swap.create(:deadline => 12.weeks.from_now)
    xhr :get, :new, :user_id => users(:quentin).id
    assert_response :success
    assert /Sorry to make you wait/.match @response.body
    assert !(@swap2.users.include? users(:quentin))
  end
  
  def test_register_first_time
    login_as :aaron
    @aaron = users(:aaron)
    @swap = swaps(:registration_period)
    xhr :post, :create, :user_id => @aaron.id
    assert_response :success
    assert /Thanks/.match @response.body
    @swap.reload
    assert @swap.users.include? @aaron
  end
  
  def test_register_subsequent_time
    login_as :quentin
    @quentin = users(:quentin)
    @swap = Swap.create(:deadline => 8.weeks.from_now)
    Confirmation.create :assignment => assignments(:one)
    xhr :post, :create, :user_id => @quentin.id
    assert_response :success
    assert /Thanks/.match @response.body
    assert @swap.users.include? @quentin
  end
  
  def test_cancel
    login_as :quentin
    @quentin = users(:quentin)
    @swap = swaps(:registration_period)
    assert @swap.users.include? @quentin
    xhr :delete, :destroy, :user_id => @quentin.id, :id => registrations(:one)
    assert_response :success
    assert /cancelled/.match @response.body
    assert /SIGN UP/.match @response.body
    @swap.reload
    assert !(@swap.users.include? @quentin)    
  end
  
  def test_display_closed_registration
    login_as :aaron
    swaps(:expired).move_to_top
    @swap = Swap.current
    xhr :get, :new, :user_id => users(:aaron).id
    assert_response :success
    assert /current swap is now closed/.match @response.body
  end
end
