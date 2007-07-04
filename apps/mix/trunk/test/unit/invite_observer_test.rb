require File.dirname(__FILE__) + '/../test_helper'

class InviteObserverTest < Test::Unit::TestCase
  fixtures :invites, :users

  def setup
    ActionMailer::Base.deliveries = []
    @emails = ActionMailer::Base.deliveries
  end

  def test_mail_on_delivery
    @invite = invites(:pending)
    assert_difference(@emails, :size, 1) do
      @invite.deliver
    end
  end
  
  def test_dont_mail_on_create
    assert_no_difference(@emails, :size) do
      Invite.create(:from => users(:quentin), :to => 'jed@vitamin-j.com')
    end
  end
  
  def test_dont_mail_on_accept
    @invite = invites(:open)
    assert_no_difference(@emails, :size) do
      @invite.accept(users(:aaron))
    end
  end
end
