# INTENTIONALLY VULNERABLE CODE — for teaching only.
# These routes are only mounted when VulnerableDemos.enabled? is true
# (development and test, or ENABLE_VULNERABLE_DEMOS=1). Never enable them in production.
module Vulnerable
  class BaseController < ApplicationController
    before_action :ensure_demos_enabled

    private
      def ensure_demos_enabled
        head :not_found unless VulnerableDemos.enabled?
      end
  end
end
