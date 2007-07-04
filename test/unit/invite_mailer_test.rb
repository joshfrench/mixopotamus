require File.dirname(__FILE__) + '/../test_helper'

class InviteMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  fixtures :users, :invites

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    
    @invite = invites(:open)
    @user = @invite.user
  end
  
  def test_invite_for
    response = InviteMailer.create_invite_for(@invite)
    assert_match /#{@user.login}/, response.subject
    assert_match /#{@user.login}/, response.body
    assert_match /#{@invite.uuid}/, response.body
    assert_equal @invite.to_email, response.to[0]
    assert_match /#{@invite.message}/, response.body
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/invite_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
