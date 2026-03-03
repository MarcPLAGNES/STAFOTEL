# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  csp_report_only = ENV.fetch("CSP_REPORT_ONLY", "true") == "true"

  config.content_security_policy do |policy|
    # Default: only self.
    policy.default_src :self

    # Scripts: self + trusted CDNs. Inline scripts must use a nonce.
    policy.script_src :self, "https://cdnjs.cloudflare.com", "https://cdn.jsdelivr.net"

    # Styles: keep unsafe-inline temporarily due many inline style attributes in views.
    policy.style_src :self, :unsafe_inline, "https://fonts.googleapis.com", "https://cdnjs.cloudflare.com", "https://cdn.jsdelivr.net"

    # Fonts
    policy.font_src :self, :data, "https://fonts.gstatic.com"

    # Images
    policy.img_src :self, :https, :data, :blob

    # Connections (AJAX/WebSocket)
    policy.connect_src :self, :https

    # Additional hardening
    policy.base_uri :self
    policy.frame_ancestors :self
    policy.object_src :none

    # Specify URI for violation reports
    policy.report_uri "/csp-violation-report"
  end

  # Generate random nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src)

  # Progressive rollout: keep report-only by default, switch to strict with CSP_REPORT_ONLY=false.
  config.content_security_policy_report_only = csp_report_only
end
