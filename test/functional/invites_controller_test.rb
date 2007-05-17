require File.dirname(__FILE__) + '/../test_helper'
require 'invites_controller'

# Re-raise errors caught by the controller.
class InvitesController; def rescue_action(e) raise e end; end

class InvitesControllerTest < Test::Unit::TestCase
  fixtures :invites, :users

  def setup
    @controller = InvitesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_accept_open_invite
    invite = invites(:open)
    get :show, { :id => invite.uuid }
    assert_response :redirect
    assert_redirected_to :controller => 'account', :action => 'signup', :email => invite.to_email
  end
  
  def test_deny_redeemed_invite
    invite = invites(:accepted)
    get :show, :id => invite.uuid
    assert_response :success
    assert flash.has_key? :error
  end
  
  def test_catch_missing_invite
    get :show, :id => 'notavalidid'
    assert_response :success
    assert flash.has_key? :error
  end

  def test_create_new_invite
    assert_difference(Invite, :count, 1) do
      post :create, { :to => 'jed@vitamin-j.com', :from => users(:quentin) }
    end
  end
end
