class QuoteSubmissionMailer < ApplicationMailer
  default to: -> { quote_email }, from: -> { admin_email }

  def new_quote
    @quote = params[:quote]
    @contact = @quote.contact
    @service = @quote.service
    mail(subject: "Nouvelle demande de devis - #{@service.name}")
  end

  private

  def quote_email
    "qualite@stafotel.com"
  end

  def admin_email
    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
