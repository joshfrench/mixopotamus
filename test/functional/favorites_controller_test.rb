require File.dirname(__FILE__) + '/../test_helper'
require 'favorites_controller'

# Re-raise errors caught by the controller.
class FavoritesController; def rescue_action(e) raise e end; end

class FavoritesControllerTest < Test::Unit::TestCase
  fixtures :favorites, :users, :assignments, :swapsets, :swaps, :registrations

  def setup
    @controller = FavoritesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @aaron = users(:aaron)
    @quentin = users(:quentin)
    @swapset = swapsets(:alligator)
    @swapset.assign @aaron
  end

  def test_create
    login_as :aaron
    assert_difference(Favorite, :count, 1) do
      xhr :post, :create, { :user_id => @aaron.id, 
                            :favorite => { :to => @quentin.id, :swapset => @swapset.id }}
    end
    assert_response :success
    assert /star_on.png/.match(@response.body)
  end
  
  def test_destroy
    login_as :aaron
    assert_difference(Favorite, :count, -1) do
      xhr :delete, :destroy, { :user_id => @aaron.id, :id => favorites(:aaron_to_quentin).id }
    end
    assert_response :success
    assert /star_off.png/.match(@response.body)
  end
end
