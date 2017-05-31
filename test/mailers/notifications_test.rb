require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "standard" do
    mail = NotificationsMailer.standard
    assert_equal "Standard", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
