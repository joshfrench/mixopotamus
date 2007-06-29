require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class FirstSignupTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def test_first_round
    
    initial_setup
    
    ### Admin (that's me!) logs in and sets up some accounts
    
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
    josh.views_account
    josh.sends_invite(:to => 'jed@vitamin-j.com', :message => 'check out my hippopotamus')
    josh.sends_invite(:to => 'furry@vitamin-j.com', :message => 'check out my hippopotamus')
    josh.sends_invite(:to => 'vaclav@vitamin-j.com', :message => 'check out my hippopotamus')
    josh.sends_invite(:to => 'morgan@vitamin-j.com', :message => 'check out my hippopotamus')
    josh.sends_invite(:to => 'anne@vitamin-j.com', :message => 'check out my hippopotamus')
    
    ### people show up and register
    jed = new_session
    jed.redeems_invite 'jed'
    jed.signs_up
    jed.logs_out
    
    anne = new_session
    morgan = new_session
    
    anne.redeems_invite 'anne'
    morgan.redeems_invite 'morgan'
    
    anne.signs_up
    morgan.signs_up
    
    anne.views_account
    anne.logs_out
    
    morgan.views_account
    
    furry = new_session
    vaclav = new_session
    
    furry.redeems_invite 'furry'
    furry.signs_up
    furry.views_account
    furry.unregisters
    
    vaclav.redeems_invite 'vaclav'
    
    furry.views_account
    morgan.logs_out
    
    vaclav.signs_up
    vaclav.views_account
    furry.registers
    furry.views_account
    furry.logs_out
    vaclav.logs_out
    
    josh.logs_out
    assert_equal 6, Swap.current.users.count
  end
  
end

module IntegrationHelper
  module AppDSL
    def views_account
      get default_url
      assert_no_tag 'h2', :content => /past swaps/i 
      assert_no_tag 'h2', :content => /current_swap/i
    end
  end
end