require File.dirname(__FILE__) + '/../test_helper'
require 'swaps_controller'

# Re-raise errors caught by the controller.
class SwapsController; def rescue_action(e) raise e end; end

class SwapsControllerTest < Test::Unit::TestCase
  fixtures :swaps

  def setup
    @controller = SwapsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
