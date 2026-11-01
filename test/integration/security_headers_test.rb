require "test_helper"

# OWASP A05:2021 Security Misconfiguration
class SecurityHeadersTest < ActionDispatch::IntegrationTest
  test "responses carry a strict content security policy and hardening headers" do
    get root_path
    csp = response.headers["Content-Security-Policy"]
    assert_includes csp, "script-src 'self'"
    assert_includes csp, "frame-ancestors 'none'"
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
    assert_equal "SAMEORIGIN", response.headers["X-Frame-Options"]
  end

  test "pages require authentication" do
    get secure_documents_path
    assert_redirected_to new_session_path
  end

  test "vulnerable demos are disabled in production" do
    production = ActiveSupport::EnvironmentInquirer.new("production")
    assert_not VulnerableDemos.enabled?(env: production, flag: nil)
  end
end
