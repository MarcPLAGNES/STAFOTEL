# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    # Default: only self for most resources
    policy.default_src :self, :https

    # Allow scripts from self and trusted CDNs
    policy.script_src :self, :https, "https://cdnjs.cloudflare.com", "https://cdn.jsdelivr.net"

    # Allow styles from self, trusted CDNs, and Google Fonts
    policy.style_src :self, :https, "https://fonts.googleapis.com", "https://cdnjs.cloudflare.com", "https://cdn.jsdelivr.net"

    # Allow fonts from self, Google Fonts, and data URIs
    policy.font_src :self, :https, :data, "https://fonts.gstatic.com"

    # Allow images from self, data URIs, and HTTPS sources
    policy.img_src :self, :https, :data

    # Disable plugins
    policy.object_src :none

    # Only allow HTTPS connections
    policy.connect_src :self, :https

    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src style-src)

  # Report violations without enforcing the policy (safe mode for testing)
  config.content_security_policy_report_only = true
end
