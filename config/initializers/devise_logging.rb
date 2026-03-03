if Rails.env.production?
  ActiveSupport::Notifications.subscribe("warden") do |_name, _start, _finish, _id, payload|
    event = payload[:message].to_s
    next unless event.in?(["authentication", "failure", "fetch", "logout"])

    request = payload[:request]
    user = payload[:user]

    Rails.logger.info(
      {
        source: "warden",
        event: event,
        path: request&.path,
        method: request&.request_method,
        ip: request&.ip,
        email: request&.params&.dig("user", "email"),
        user_id: user&.id
      }.to_json
    )
  end
end
