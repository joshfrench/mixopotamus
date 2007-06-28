require "#{File.dirname(__FILE__)}/../test_helper"

class FirstRoundTest < ActionController::IntegrationTest
  
  def setup
    [User, Swap, Registration, Swapset, Assignment, Favorite, Confirmation, Invite].each do |klass|
      klass.delete_all
      assert_equal 0, klass.count
    end
    Swap.create :deadline => SWAP_LENGTH.from_now
    josh = User.create :login => "josh", :password => "foobar", :password_confirmation => "foobar",
                :email => "josh@vitamin-j.com", :address => "155 23rd St\nBrooklyn, NY\n11232"
    5.times { josh.give_invite }
  end
  
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
    anne.redeems_invite 'anne'
    
    morgan = new_session
    morgan.redeems_invite 'morgan'
    
    anne.logs_out
    morgan.logs_out

  end
  
  
  private
  
  def new_session
    open_session do |sess|
      sess.extend(AppDSL)
      yield sess if block_given?
    end
  end
  
  module AppDSL
    attr_reader :person
    
    def goes_to_login
      get login_url
      assert_response :success
      assert_template 'account/login'
    end
    
    def logs_in_as(person)
        @person = User.find_by_login(person)
        post login_url, :email => @person.email, :password => 'foobar'
        assert_response :redirect
        follow_redirect!
        assert_template "account/show"
    end
    
    def logs_out
      get logout_url
      assert_response :success
      assert_template "account/login"
    end
    
    def sends_invite(options)
      assert_difference current_user, :invite_count, (current_user.id == 1 ? 0 : -1) do
        xhr :post, invites_path(current_user), { :user_id => current_user.id, :invite => options }
        assert_response :success
      end
    end
    
    def redeems_invite(person)
      get redeem_invite_url(:id => Invite.find_by_to_email("#{person}@vitamin-j.com").uuid)
      assert_response :redirect
      follow_redirect!
      assert_template "account/signup"
      assert session[:invite]
    end
    
    def signs_up    
      assert_difference User, :count do
        post signup_path, { :user => { :login => session[:invite].to_email.split('@').first, 
                                       :email => session[:invite].to_email, 
                                       :password => 'foobar', :password_confirmation => 'foobar', 
                                       :address => "123 Street Name\nCity, ST\n12345" } }
      end
      assert_response :redirect
      follow_redirect!
      assert_template "account/show"
      assert_response :success
      assert_tag 'h2', :content => /Welcome/
      assert_tag 'p', :content => /you are signed up/i
      assert_no_tag 'h2', :content => /past swaps/i 
      assert_no_tag 'h2', :content => /current_swap/i
    end
    
    def registers_for_swap(swap)
    end
    
    def unregisters_for_swap(swap)
    end
    
    def confirms_assignment(assignment)
    end
    
    def unconfirms_assignment(assignment)
    end
    
    def stars_assignment(assignment)
    end
    
    def unstars_assignment(assignment)
    end
    
    def current_user
      @current_user ||= (session[:user] && User.find_by_id(session[:user])) || :false
    end
    
    private
    
    def assert_difference(object, method = nil, difference = 1)
      initial_value = object.send(method)
      yield
      assert_equal initial_value + difference, object.send(method), "#{object}##{method}"
    end

    def assert_no_difference(object, method, &block)
      assert_difference object, method, 0, &block
    end
    
  end
  
end