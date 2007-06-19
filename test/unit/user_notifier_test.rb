require File.dirname(__FILE__) + '/../test_helper'

class UserNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting
  
  fixtures :users, :swaps

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    
    @quentin = users(:quentin)
  end
  
  def test_signup
    response = UserNotifier.create_signup_notification(@quentin)
    assert_match /Welcome/, response.subject
    assert_match /#{@quentin.first_name}/, response.body
    assert_match /Thanks for joining us/, response.body
    assert_equal @quentin.email, response.to[0]
  end
  
  def test_assignment
    @swap = swaps(:mix_period)
    @swap.move_to_top
    response = UserNotifier.create_assignment_notification(@quentin)
    assert_match /#{@quentin.first_name}/, response.body
    assert_match /Your swap assignment is now available/, response.body
    assert_equal @quentin.email, response.to[0]
  end
  
  def test_mailing_reminder
    @swap = swaps(:mix_period)
    @swap.move_to_top
    response = UserNotifier.create_mailing_reminder(@quentin)
    assert_match /your mixes must be in the mail no later than/, response.body
    assert_match /#{@swap.deadline.strftime "%B %d"}/, response.body
    assert_equal @quentin.email, response.to[0]
  end
  
  def test_registration_reminder
    @swap = swaps(:registration_period)
    response = UserNotifier.create_registration_reminder(@quentin)
    assert_match /the last day to complete your swap surveys is/, response.body
    assert_match /#{@swap.registration_deadline.to_s :small}/, response.body
    assert_equal @quentin.email, response.to[0]
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
