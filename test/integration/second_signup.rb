require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class SecondSignupTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def setup
    super
     %w{ jed furry vaclav anne morgan }.each do |user|
        create_user user
      end
      assert_equal 6, Swap.current.users.size
      advance_timeline
      RakeHelper.make_sets
      advance_timeline :by => (6.weeks + 1.hour)
      RakeHelper.new_swap
      assert Swap.previous.deadline.just_passed?
  end
  
  def test_second_signup
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
    josh.views_swapsets
    
    josh.confirms Assignment.find_by_swapset_id_and_user_id(User.find(1).swapsets.first.id, User.find_by_login('jed'))
    
    josh.confirms Assignment.find_by_swapset_id_and_user_id(User.find(1).swapsets.first.id, User.find_by_login('anne'))
    
    jed = new_session
    jed.goes_to_login
    jed.logs_in_as 'jed'
    jed.checks_confirmations
    jed.sends_invite :to => 'jim@vitamin-j.com', :message => "This is a great hippo"
    jed.logs_out
    
    morgan = new_session
    morgan.goes_to_login
    morgan.logs_in_as 'morgan'
    morgan.feels_the_burn
    morgan.logs_out
    
    furry = new_session
    furry.goes_to_login
    furry.logs_in_as 'furry'
    
    josh.stars Assignment.find_by_swapset_id_and_user_id(User.find(1).swapsets.first.id, User.find_by_login('furry'))
    
    furry.checks_confirmations
    
    josh.confirms Assignment.find_by_swapset_id_and_user_id(User.find(1).swapsets.first.id, User.find_by_login('morgan'))
    
    josh.stars Assignment.find_by_swapset_id_and_user_id(User.find(1).swapsets.first.id, User.find_by_login('morgan'))
    
    morgan.logs_in_as 'morgan'
    morgan.checks_confirmations
    morgan.registers
    
    vaclav = new_session
    vaclav.goes_to_login
    vaclav.logs_in_as 'vaclav'
    vaclav.feels_the_burn
    vaclav.logs_out
    
    anne = new_session
    anne.goes_to_login
    anne.logs_in_as 'anne'
    anne.checks_confirmations
    anne.sends_invite :to => "herboyfriend@vitamin-j.com", :message => "What an excellent hippo"
    
  end
  
end

module IntegrationHelper
  module AppDSL
    def views_swapsets
      get default_url
      assert_response :success
      assert_tag 'h2', :content => /current swap/i
      assert_tag 'span', :content => /furry/i
      assert_tag 'h2', :content => /next swap/i
    end
    
    def checks_confirmations
      get default_url
      assert_response :success
      assert_tag :h2, :content => /next swap/i
      assert_tag :p, :content => /not signed up/
    end
    
    def feels_the_burn
      get default_url
      assert_response :success
      assert_tag :p, :content => /confirm you sent your mixes/ 
    end
  end
end