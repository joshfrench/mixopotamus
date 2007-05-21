require File.dirname(__FILE__) + '/../test_helper'
require 'registrations_controller'

# Re-raise errors caught by the controller.
class RegistrationsController; def rescue_action(e) raise e end; end

class RegistrationsControllerTest < Test::Unit::TestCase
  
  fixtures :users, :swaps
  
  def setup
    @controller = RegistrationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_burned
    login_as :quentin
    # create a new swap so quentin's last swap will fail ok_to_play?
    @swap = Swap.create(:deadline => 8.weeks.from_now)
    xhr :get, :new, :user_id => users(:quentin).id
    assert_response :success
    assert /Does not play well/.match @response.body
  end
  
  def test_register_first_time
    
  end
  
  def test_register_subsequent_time
    
  end
  
  def test_cancel
    
  end
  
  def test_display_closed_registration
    
  end
end
