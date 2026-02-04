class ContactSubmissionMailer < ApplicationMailer
  default to: -> { admin_email }, from: -> { admin_email }

  def new_contact
    @contact = params[:contact]
    @message = params[:message]
    mail(subject: "Nouveau message - Contact")
  end

  private

  def admin_email
    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
