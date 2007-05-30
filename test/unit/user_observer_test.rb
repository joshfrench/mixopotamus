require File.dirname(__FILE__) + '/../test_helper'

class UserObserverTest < Test::Unit::TestCase
  fixtures :swaps, :users

  def test_register_user_in_open_swap
    @swap = swaps(:registration_period)
    assert_difference(Registration, :count, 1) do
      @user = create_user
    end
    assert @swap.users.include?(@user)
  end
  
  def test_dont_register_user_in_closed_swap
    # create closed swap
    @swap = Swap.create(:deadline => 1.week.from_now)
    assert_no_difference(Registration, :count) do
      @user = create_user
    end
    assert !(@swap.users.include? @user)
  end
  
  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire', :address => 'Quire Ave.' }.merge(options))
    end
end
