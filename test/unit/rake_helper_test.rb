require File.dirname(__FILE__) + '/../test_helper'
require 'rake_helper'

class RakeHelperTest < Test::Unit::TestCase
  
  fixtures :users, :swaps, :swapsets, :invites

  def setup
    @swap = swaps(:registration_period)
    @swap.swapsets.each { |set| set.destroy } # clean slate
    pack_set
    ActionMailer::Base.deliveries = []
    @emails = ActionMailer::Base.deliveries
  end
  
  def test_dont_make_swap_before_mailing_deadline
    @swap.deadline = 1.day.from_now.at_midnight
    @swap.save
    assert !(@swap.open?)
    assert_no_difference(Swap, :count) do
      RakeHelper.new_swap if @swap.deadline.just_passed?
    end
  end
  
  def test_make_swap_after_mailing_deadline
    @swap.deadline = Time.now.at_midnight
    @swap.save
    assert_difference(Swap, :count, 1) do
      RakeHelper.new_swap if @swap.deadline.just_passed?
    end
  end
  
  def test_dont_make_sets_before_reg_closes
    @swap.deadline = (Time.now.at_midnight+REGISTRATION_LENGTH)+1.day
    @swap.save
    assert @swap.open?
    assert_no_difference(Swapset, :count) do
      RakeHelper.make_sets if @swap.registration_deadline.just_passed?
    end
  end
  
  def test_make_sets_after_reg_closes
    @swap.deadline = Time.now + 5.weeks + 6.days + 12.hours
    @swap.save
    assert !(@swap.open?)
    assert_difference(Swapset, :count) do
      RakeHelper.make_sets if @swap.registration_deadline.just_passed?
    end
  end
  
  def test_dont_email_before_reg_reminder
    @swap.deadline = Time.now + 6.weeks + 6.days
    @swap.save
    assert ! (Time.now-@swap.registration_reminder).between?(0, 24.hours)
    assert_no_difference(@emails, :size) do
      RakeHelper.remind_registration if @swap.registration_reminder.just_passed?
    end
  end
  
  def test_email_after_reg_reminder
    @swap.deadline = Time.now + 7.weeks
    @swap.save
    assert (Time.now-@swap.registration_reminder).between?(0, 24.hours)
    assert_difference(@emails, :size, @swap.users.size) do
      RakeHelper.remind_registration if @swap.registration_reminder.just_passed?
    end
  end
  
  def test_dont_email_before_mail_reminder
    @swap.deadline = Time.now + 7.days + 12.hours
    @swap.save
    assert ! (Time.now-@swap.mailing_reminder).between?(0, 24.hours)
    assert_no_difference(@emails, :size) do
      RakeHelper.hassle_slowpokes if @swap.mailing_reminder.just_passed?
    end
  end
  
  def test_email_after_mail_reminder
    @swap.deadline = 1.week.from_now
    @swap.save
    assert (Time.now-@swap.mailing_reminder).between?(0, 24.hours)
    assert_difference(@emails, :size, @swap.users.size) do
      RakeHelper.hassle_slowpokes if @swap.mailing_reminder.just_passed?
    end
  end
  
  def test_signup_notifier
    assert User.recent_signups.size > 0
    assert_difference(@emails, :size, 1) do
      RakeHelper.send_signup_report
    end
  end
  
  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire', :address => 'Quire Ave.' }.merge(options))
    end
    
    def pack_set
       ('A'..'E').to_a.each do |i|
          user = create_user(:email => "user#{i}@vitamin-j.com", :login => "user#{i}")
          # duh... users are auto-registered on create during an open swap
          # so don't register them again here
        end
    end
  
end