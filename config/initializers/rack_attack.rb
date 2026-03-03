# Rack::Attack configuration for rate limiting
# Protects against brute force attacks, spam, and excessive traffic

class Rack::Attack
  # Store for tracking requests (in-memory by default, use Redis in production)
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # Throttle general requests: 300 per 5 minutes per IP
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Throttle login attempts: 30 per 5 minutes per IP+email
  # Avoids blocking all users when the app is behind a reverse proxy/shared IP.
  throttle("logins/ip_email", limit: 30, period: 5.minutes) do |req|
    if req.path == "/users/sign_in" && req.post?
      email = req.params.dig("user", "email").to_s.strip.downcase
      "#{req.ip}:#{email}" if email.present?
    end
  end

  # Throttle login attempts by email: 10 per 5 minutes per email
  throttle("logins/email", limit: 10, period: 5.minutes) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.params["user"]["email"].presence
    end
  end

  # Throttle form submissions: 50 per 5 minutes per IP
  throttle("forms/ip", limit: 50, period: 5.minutes) do |req|
    req.ip if %w(
      /contacts
      /applications
      /appointments
      /quotes
    ).any? { |path| req.path.start_with?(path) && req.post? }
  end

  # Response when throttled
  self.throttled_response = lambda do |env|
    retry_after = (env["RateLimit-Reset"].to_i - Time.now.to_i).abs
    [
      429,
      {
        "Content-Type" => "application/json",
        "Retry-After" => retry_after.to_s
      },
      [
        JSON.generate({
          error: "Too many requests",
          retry_after: retry_after
        })
      ]
    ]
  end
end

# Whitelist health check endpoint
Rack::Attack.safelist("healthcheck") do |req|
  req.path == "/up"
end
