# A05 Security Misconfiguration — a strict Content Security Policy is a second layer
# against XSS: even if markup is injected, the browser refuses inline scripts.
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src  :self
    policy.style_src   :self
    policy.img_src     :self, :data
    policy.object_src  :none
    policy.base_uri    :self
    policy.form_action :self
    policy.frame_ancestors :none
  end
end
