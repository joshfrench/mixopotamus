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
    assert_match /Sorry/, @response.body
  end
  
  def test_catch_missing_invite
    get :show, :id => 'notavalidid'
    assert_response :success
    assert_match /Sorry/, @response.body
  end

  def test_create_new_invite
    login_as :aaron
    assert users(:aaron).invite_count > 0
    assert_difference(Invite, :count, 1) do
      xhr :post, :create, :invite => { :to => 'new@invite.com' }, :id => users(:aaron).id
    end
  end
  
  def test_dont_invite_existing_member
    login_as :aaron
    assert_difference(Invite, :count, 0) do
      xhr :post, :create, :invite => { :to => users(:quentin).email }, :id => users(:aaron).id
    end
  end
  
  def test_catch_open_invite
    login_as :aaron
    xhr :post, :create, :invite => { :to => invites(:open).to_email }, :id => users(:aaron).id
    assert_template "invites/confirm"
  end
  
  def test_cancel_invite
    login_as :quentin
    @invite = invites(:pending)
    assert_difference(Invite, :count, -1) do
      xhr :post, :destroy, :id => @invite.id, :user_id => users(:quentin).id, :method => :delete
    end
    assert_template "invites/destroy"
  end
  
  def test_confirm_invite
    login_as :quentin
    @quentin = users(:quentin)
    @quentin.give_invite
    @invite = invites(:pending)
    xhr :post, :confirm, :id => @invite.id, :user_id => @quentin.id
    @invite.reload
    assert_equal "open", @invite.status
  end
  
  def test_authorize_create
    @invite = invites(:pending)
    login_as :quentin
    assert_no_difference(Invite, :count) do
      xhr :post, :create, :id => users(:aaron).id, :invite => { :to => 'whatever@vitamin-j.com' }
    end
  end
  
  def test_authorize_confirm
    login_as :aaron
    @invite = invites(:pending)
    xhr :post, :confirm, :id => @invite.id, :user_id => users(:quentin).id
    @invite.reload
    assert_equal 'pending', @invite.status
  end
  
  def test_authorize_destroy
    login_as :aaron
    @invite = invites(:pending)
    assert_no_difference(Invite, :count) do
      xhr :delete, :destroy, :id => @invite.id, :user_id => users(:quentin).id
    end
  end
  
end
