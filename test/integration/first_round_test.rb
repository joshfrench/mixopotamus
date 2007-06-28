require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class FirstRoundTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def test_first_round
    
    ### Admin (that's me!) logs in and sets up some accounts
    
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
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
    
    anne.logs_out
    
    furry = new_session
    vaclav = new_session
    
    furry.redeems_invite 'furry'
    furry.signs_up
    furry.unregisters
    
    vaclav.redeems_invite 'vaclav'
    
    morgan.logs_out
    
    vaclav.signs_up
    
    furry.registers
    furry.logs_out
    vaclav.logs_out
  end
  
end