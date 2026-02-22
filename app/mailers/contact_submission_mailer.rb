class ContactSubmissionMailer < ApplicationMailer
  default to: -> { admin_email }, from: -> { admin_email }

  def new_contact
    @contact = params[:contact]
    @message = params[:message]
    mail(to: recipient_email, subject: "Nouveau message - Contact")
  end

  private

  def recipient_email
    params[:recipient_email].presence || admin_email
  end

  def admin_email
    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
