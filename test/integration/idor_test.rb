require "test_helper"

# OWASP A01:2021 Broken Access Control — Insecure Direct Object Reference
class IdorTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:alice) }

  test "vulnerable endpoint shows another user's document" do
    get vulnerable_document_path(documents(:bob_salary))
    assert_response :success
    assert_includes response.body, "confidential salary"
  end

  test "secure endpoint returns 404 for another user's document" do
    get secure_document_path(documents(:bob_salary))
    assert_response :not_found
  end

  test "secure endpoint shows the user's own document" do
    get secure_document_path(documents(:alice_notes))
    assert_response :success
  end
end
