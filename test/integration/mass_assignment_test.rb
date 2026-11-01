require "test_helper"

# OWASP A01:2021 Broken Access Control — privilege escalation through mass assignment
class MassAssignmentTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:alice) }

  test "vulnerable update lets a user make herself admin" do
    patch vulnerable_profile_path, params: { user: { display_name: "Alice", role: "admin" } }
    assert users(:alice).reload.admin?
  end

  test "secure update ignores the role parameter" do
    patch secure_profile_path, params: { user: { display_name: "Alice B.", role: "admin" } }
    alice = users(:alice).reload
    assert_not alice.admin?
    assert_equal "Alice B.", alice.display_name
  end
end
