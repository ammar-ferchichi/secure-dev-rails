require "test_helper"

# OWASP A07:2021 Identification and Authentication Failures — login brute force
class BruteForceTest < ActionDispatch::IntegrationTest
  test "login is rate limited after 10 attempts in 3 minutes" do
    10.times { sign_in_as users(:alice), password: "wrong" }
    assert_equal "Try another email address or password.", flash[:alert]

    sign_in_as users(:alice), password: "wrong"
    assert_redirected_to new_session_url
    assert_equal "Try again later.", flash[:alert]
  end

  test "wrong password does not reveal whether the email exists" do
    sign_in_as users(:alice), password: "wrong"
    unknown_email_alert = flash[:alert]
    post session_path, params: { email_address: "nobody@example.com", password: "wrong" }
    assert_equal unknown_email_alert, flash[:alert]
  end
end
