module IntegrationHelper
  
  def setup
    [User, Swap, Registration, Swapset, Assignment, Favorite, Confirmation, Invite].each do |klass|
      klass.delete_all
    end
    Swap.create :deadline => SWAP_LENGTH.from_now
    josh = User.create :login => "josh", 
                       :password => "foobar", :password_confirmation => "foobar",
                       :email => "josh@vitamin-j.com", 
                       :address => "155 23rd St\nBrooklyn, NY\n11232"
    Swap.current.register josh
    5.times { josh.give_invite }
  end
  
  private

  def new_session
    open_session do |sess|
      sess.extend(AppDSL)
      yield sess if block_given?
    end
  end
  
  def advance_timeline(options={})
    options[:by] ||= 7.weeks
    Swap.find(:all).each do |swap|
      swap.update_attribute(:deadline, swap.deadline-options[:by])
    end
  end
  
  def create_user(name)
    User.create :login => name, 
                       :password => "foobar", :password_confirmation => "foobar",
                       :email => "#{name}@vitamin-j.com", 
                       :address => "155 23rd St\nBrooklyn, NY\n11232"
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
        current_user.reload
      end
    end
  
    def redeems_invite(person)
      get redeem_invite_path(:id => Invite.find_by_to_email("#{person}@vitamin-j.com").uuid)
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
  
    def registers
      assert_difference Registration, :count do
        xhr :post, registrations_path(current_user)
      end
      assert_response :success
      assert_match /thanks for signing up/i, @response.body
      assert current_user.reload.registered_for?(Swap.current)
    end
  
    def unregisters
      assert_difference Registration, :count, -1 do
        xhr :delete, registration_path(:user_id => current_user.id,
                                   :id => current_user.registrations.find_by_swap_id(Swap.current))
      end
      assert_response :success
      assert !(current_user.registered_for? Swap.current)
      assert_match /registration cancelled/i, @response.body
    end
  
    def confirms(assignment)
      xhr :post, confirmations_path(:user_id => current_user, :assign => assignment)
      assert_response :success
      assert_match /mail_on/, @response.body
    end
  
    def unconfirms(assignment)
    end
  
    def stars(assignment)
      xhr :post, favorites_path(:user_id => current_user, :assign => assignment)
      assert_response :success
      assert /star_on/.match @response.body
    end
  
    def unstars(assignment)
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