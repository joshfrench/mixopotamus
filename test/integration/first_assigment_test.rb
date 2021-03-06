require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class FirstAssignmentTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def test_get_assignments
    initial_setup
    
    %w{ jed furry vaclav anne morgan }.each do |user|
      create_user user
    end
    assert_equal 6, Swap.current.users.size
    advance_timeline
    RakeHelper.make_sets
    
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
    josh.views_swapsets
    josh.does_not_see_past_sets
    
    furry = new_session
    furry.goes_to_login
    furry.logs_in_as 'furry'
    furry.does_not_see_past_sets
    
    josh.logs_out
    
    morgan = new_session
    morgan.goes_to_login
    morgan.logs_in_as 'morgan'
    
    furry.views_swapsets
    furry.logs_out
    
    morgan.does_not_see_past_sets
    morgan.views_swapsets
    morgan.logs_out
  end
    
end

module IntegrationHelper
  module AppDSL
    def views_swapsets
      get default_url
      assert_response :success
      assert_tag 'h2', :content => /current swap/i
      assert_tag 'p', :content => /mailing deadline for this swap/i
      user = (Swap.current.users - [current_user])[rand(5)]
      assert_tag 'span', :content => /#{user.login}/i
      assert_no_tag 'h2', :content => /next swap/i
      assert_no_tag :h2, :content => /past swaps/i
    end
  end
end