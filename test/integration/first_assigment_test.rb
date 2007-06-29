require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../integration_helper"

class FirstSignupTest < ActionController::IntegrationTest
  include IntegrationHelper
  
  def setup
    super
    %w{ jed furry vaclav anne morgan }.each do |user|
      create_user user
    end
    assert_equal 6, Swap.current.users.size
    advance_timeline_by
    RakeHelper.make_sets
  end
  
  def test_get_assignments
    josh = new_session
    josh.goes_to_login
    josh.logs_in_as 'josh'
    josh.get_my_set
  end
  
  def create_user(name)
    User.create :login => name, 
                       :password => "foobar", :password_confirmation => "foobar",
                       :email => "#{name}@vitamin-j.com", 
                       :address => "155 23rd St\nBrooklyn, NY\n11232"
  end
    
end

module IntegrationHelper
  module AppDSL
    def get_my_set
      get default_url
      assert_response :success
      assert_tag 'h2', :content => /current swap/i
      assert_tag 'span', :content => /furry/i
      assert_no_tag 'h2', :content => /next swap/i
    end
  end
end