require File.dirname(__FILE__) + '/../test_helper'
require 'swapsets_controller'

# Re-raise errors caught by the controller.
class SwapsetsController; def rescue_action(e) raise e end; end

class SwapsetsControllerTest < Test::Unit::TestCase
  fixtures :swapsets, :users, :swaps

  def setup
    @controller = SwapsetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    login_as :quentin
    get :index
    
  end
end
