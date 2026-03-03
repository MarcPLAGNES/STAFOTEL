class CspReportsController < ActionController::Base
  skip_forgery_protection

  def create
    payload = request.request_parameters.presence || parse_raw_body
    report = payload["csp-report"] || payload

    Rails.logger.warn(
      {
        source: "csp",
        event: "violation",
        document_uri: report["document-uri"],
        blocked_uri: report["blocked-uri"],
        violated_directive: report["violated-directive"],
        effective_directive: report["effective-directive"],
        original_policy: report["original-policy"],
        referrer: report["referrer"],
        user_agent: request.user_agent
      }.to_json
    )

    head :no_content
  end

  private

  def parse_raw_body
    raw = request.raw_post.to_s
    return {} if raw.blank?

    JSON.parse(raw)
  rescue JSON::ParserError
    {}
  end
end
