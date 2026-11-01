require "test_helper"

# OWASP A03:2021 Injection — stored Cross-Site Scripting
class XssTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:bob) }

  test "vulnerable page renders the script tag as-is" do
    get vulnerable_document_path(documents(:bob_xss))
    assert_includes response.body, %(<script>alert("XSS")</script>)
  end

  test "secure page escapes the script tag" do
    get secure_document_path(documents(:bob_xss))
    assert_not_includes response.body, %(<script>alert("XSS")</script>)
    assert_includes response.body, "&lt;script&gt;"
  end
end
