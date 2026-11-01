ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

module SignInHelper
  def sign_in_as(user, password: "password123")
    post session_path, params: { email_address: user.email_address, password: password }
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper

  # Login rate limiting counts attempts in Rails.cache; start every test from zero.
  setup { Rails.cache.clear }
end
