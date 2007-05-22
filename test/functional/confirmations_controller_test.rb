require File.dirname(__FILE__) + '/../test_helper'
require 'confirmations_controller'

# Re-raise errors caught by the controller.
class ConfirmationsController; def rescue_action(e) raise e end; end

class ConfirmationsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ConfirmationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
