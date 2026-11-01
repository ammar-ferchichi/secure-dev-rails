require "test_helper"

# OWASP A03:2021 Injection
class SqlInjectionTest < ActionDispatch::IntegrationTest
  PAYLOAD = "%') OR 1=1 --"

  setup { sign_in_as users(:alice) }

  test "vulnerable search leaks other users' documents" do
    get vulnerable_documents_path, params: { q: PAYLOAD }
    assert_response :success
    assert_includes response.body, "Bob salary"
  end

  test "secure search treats the payload as plain text" do
    get secure_documents_path, params: { q: PAYLOAD }
    assert_response :success
    assert_not_includes response.body, "Bob salary"
  end

  test "secure search still finds the user's own documents" do
    get secure_documents_path, params: { q: "notes" }
    assert_includes response.body, "Alice notes"
  end
end
