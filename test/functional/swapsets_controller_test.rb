require File.dirname(__FILE__) + '/../test_helper'
require 'swapsets_controller'

# Re-raise errors caught by the controller.
class SwapsetsController; def rescue_action(e) raise e end; end

class SwapsetsControllerTest < Test::Unit::TestCase
  fixtures :swapsets

  def setup
    @controller = SwapsetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_true
    assert true
  end

end
