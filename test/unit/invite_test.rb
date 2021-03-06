require File.dirname(__FILE__) + '/../test_helper'

class InviteTest < Test::Unit::TestCase
  fixtures :invites, :users

  def setup
    @aaron = users(:aaron)
    @quentin = users(:quentin)
  end
  
  def test_to
    assert_equal 'jed@vitamin-j.com', invites(:open).to
  end
  
  def test_open?
    assert invites(:open).open?
    assert !invites(:accepted).open?
  end
  
  def test_accepted?
    assert invites(:accepted).accepted?
    assert !invites(:open).accepted?
  end
  
  def test_is_unique?
    @user = users(:aaron)
    @invite = @user.create_invite('jed@vitamin-j.com', 'Hi this is a duplicate invite.')
    assert !(@invite.is_unique?)
  end
  
  def test_is_not_unique
    @user = users(:aaron)
    @invite = @user.create_invite('unique@vitamin-j.com', 'Hi this is a duplicate invite.')
    assert @invite.is_unique?
  end
  
  def test_should_reject_bad_email
    assert_no_difference(Invite, :count) do
      Invite.create(:from => @quentin, :to => 'not an email')
      Invite.create(:from => @quentin, :to => 'email@')
      Invite.create(:from => @quentin, :to => '@email.com')
      Invite.create(:from => @quentin, :to => nil)
    end
  end
  
  def test_should_create
    assert_difference(Invite, :count, 1) do
      @i = Invite.create(:from => @quentin, :to => 'josh@vitamin-j.com', :message => "Hi,  think you should check this out.")
    end
    assert_equal 32, @i.uuid.length
    assert_equal 'pending', @i.status
    assert_equal @quentin, @i.user
    assert_equal 'Hi,  think you should check this out.', @i.reload.message
  end
  
  def test_should_deliver
    invite = invites(:pending)
    invite.deliver
    invite.reload
    assert_equal 'open', invite.status
  end
  
  def test_should_not_invite_existing_user
    assert_no_difference(Invite, :count) do
      i = Invite.create(:from => @aaron, :to => @quentin.email, :message => "Foo")
      assert i.errors.on(:to_email)
    end
  end
  
  def test_should_not_invite_bad_email
    assert_no_difference(Invite, :count) do
      i = Invite.create(:from => users(:aaron), :to => 'test@foo', :message => "Foo")
      assert !i.valid?
      assert i.errors.on(:to_email)
      
      i = Invite.create(:from => users(:aaron), :to => nil, :message => "Foo")
      assert !i.valid?
      assert i.errors.on(:to_email)
    end
  end
  
  def test_should_accept_open_invite
    i = invites(:open)
    i.accept(@aaron)
    i.reload
    assert_equal 'accepted', i.status
    assert_not_nil i.accepted_at
  end
  
  def test_should_not_accept_invite_twice
    i = invites(:accepted)
    assert_raises RuntimeError do
      i.accept(@quentin)
    end
  end

end
