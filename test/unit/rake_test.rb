require File.dirname(__FILE__) + '/../test_helper'

class RakeTest < Test::Unit::TestCase
  
  fixtures :users, :swaps, :swapsets

  def setup
    @swap = swaps(:registration_period) 
    ActionMailer::Base.deliveries = []
    @emails = ActionMailer::Base.deliveries   
  end
  
  def test_day_before_mailing_deadline
    @swap.deadline = 1.day.from_now.at_midnight
    @swap.save
    assert !(@swap.open?)
    assert_no_difference(Swap, :count) do
      system "rake check_expire"
    end
  end
  
  def test_day_before_reg_closes
    @swap.deadline = (Time.now.at_midnight+REGISTRATION_LENGTH)+1.day
    @swap.save
    assert @swap.open?
    assert_no_difference(Swapset, :count) do
      system "rake check_expire"
    end
  end
  
  def test_day_before_reg_reminder
    @swap.deadline = Time.now + 6.weeks + 6.days
    @swap.save
    assert ! (Time.now-@swap.registration_reminder).between?(0, 24.hours)
    assert_no_difference(@emails, :size) do
      system "rake check_expire"
    end
  end
  
  def test_day_before_mail_reminder
    @swap.deadline = Time.now + 7.days + 12.hours
    @swap.save
    assert ! (Time.now-@swap.mailing_reminder).between?(0, 24.hours)
    assert_no_difference(@emails, :size) do
      system "rake check_expire"
    end
  end
  
  ### These tests seem to work ok from the console?
  
  def _test_day_after_mailing_deadline
    assert_equal Swap.current, @swap
    @swap.deadline = Time.now.at_midnight
    @swap.save
    assert_difference(Swap, :count, 1) do
      system "rake check_expire"
    end
  end
  
  def _test_day_after_reg_closes
    @swap.deadline = Time.now + 5.weeks + 6.days + 12.hours
    @swap.save
    assert !(@swap.open?)
    assert_difference(Swapset, :count) do
      system "rake check_expire"
    end
  end
  
  def _test_day_after_reg_reminder
    @swap.deadline = Time.now + 7.weeks
    @swap.save
    assert (Time.now-@swap.registration_reminder).between?(0, 24.hours)
    assert_difference(@emails, :size, @swap.users.size) do
      system "rake check_expires"
    end
  end
  
  def _test_day_after_mail_reminder
    @swap.deadline = 1.week.from_now
    @swap.save
    assert (Time.now-@swap.mailing_reminder).between?(0, 24.hours)
    assert_difference(@emails, :size, @swap.users.size) do
      system "rake check_expires"
    end
  end
  
end