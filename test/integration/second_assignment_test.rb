require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class SecondAssignmentTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def test_second_round_assignments
    initial_setup
    
    %w{ jed furry vaclav anne morgan }.each do |user|
        create_user user
      end
    advance_timeline
    RakeHelper.make_sets
    advance_timeline :by => (6.weeks + 1.hour)
    RakeHelper.new_swap
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
    josh.does_not_see_past_sets
    josh.confirms 'jed'
    josh.confirms 'morgan'
    josh.confirms 'anne'
    josh.confirms 'furry'
    
    anne = new_session
    anne.goes_to_login
    anne.logs_in_as 'anne'
    anne.does_not_see_past_sets
    
    josh.logs_out
    
    jed = new_session
    jed.goes_to_login
    jed.logs_in_as 'jed'
    
    anne.sends_invite :to => "guy@vitamin-j.com", :message => "What a pleasant hippo"
    anne.registers
    anne.logs_out
    
    jed.sends_invite :to => "jim@vitamin-j.com", :message => "Check out this hippo"
    
    guy = new_session
    guy.redeems_invite 'guy'
    guy.signs_up
    
    furry = new_session
    furry.goes_to_login
    
    guy.logs_out
    
    jed.registers
    jed.logs_out
    
    jim = new_session
    jim.redeems_invite 'jim'
    
    furry.logs_in_as 'furry'
    furry.registers
    
    jim.signs_up
    
    morgan = new_session
    morgan.goes_to_login
    morgan.logs_in_as 'morgan'
    morgan.registers
    morgan.logs_out
    
    jim.logs_out
    
    furry.logs_out

    advance_timeline
    assert_equal 6, Swap.current.users.size
    RakeHelper.make_sets
    assert_equal 2, Swapset.count
    
    jed.logs_in_as 'jed'
    jed.views_swapset
    jed.sees_past_sets
    
    jim.logs_in_as 'jim'
    jim.views_swapset
    jim.does_not_see_past_sets  ### jim just got invited
    jim.logs_out
    
    jed.logs_out
    
    anne.logs_in_as 'anne'
    
    josh.logs_in_as 'josh'
    
    anne.views_swapset
    anne.sees_past_sets
    anne.logs_out
    
    josh.sees_past_sets
    josh.sees_closed_registration
    josh.logs_out
    
    advance_timeline :by => (6.weeks + 1.hour)
    RakeHelper.new_swap
    
    josh.logs_in_as 'josh'
    josh.sees_past_sets
    
    jim.logs_in_as 'jim'
    jim.does_not_see_past_sets
    jim.confirms 'anne'
    
    anne.logs_in_as 'anne'
    anne.registers
    
  end
  
end

module IntegrationHelper
  module AppDSL
    def views_swapset
      get default_url
      assert_response :success
      assert_tag 'h2', :content => /current swap/i
      assert_tag 'p', :content => /deadline for this swap/i
      user = (Swap.current.users - [current_user])[rand(5)]
      assert_tag 'span', :content => /#{user.login}/i
      assert_no_tag 'h2', :content => /next swap/i
    end
  
    def sees_closed_registration
      get default_url
      assert_response :success
      assert_tag 'h2', :content => /current swap/i
      assert_tag 'p', :content => /check back then/i
      assert_no_tag :h2, :content => /next_swap/i
    end
  end
end