# The intentionally vulnerable demo routes are only available in development and test,
# or when explicitly enabled. They are never mounted in production by default.
module VulnerableDemos
  def self.enabled?(env: Rails.env, flag: ENV["ENABLE_VULNERABLE_DEMOS"])
    env.local? || flag == "1"
  end
end
