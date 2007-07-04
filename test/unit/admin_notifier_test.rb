require File.dirname(__FILE__) + '/../test_helper'

class AdminNotifierTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end
  
  def test_new_users
    @new_users = User.recent_signups
    response = AdminNotifier.create_new_users
    @new_users.each do |user|
      assert_match /#{user.login}/, response.body
      assert_match /#{user.accepted_invite.user.login}/, response.body if user.accepted_invite
    end
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/admin_notifier/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
