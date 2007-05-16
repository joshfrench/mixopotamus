require File.dirname(__FILE__) + '/../test_helper'
require 'invites_controller'

# Re-raise errors caught by the controller.
class InvitesController; def rescue_action(e) raise e end; end

class InvitesControllerTest < Test::Unit::TestCase
  fixtures :invites

  def setup
    @controller = InvitesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
