class ApplicationSubmissionMailer < ApplicationMailer
  default to: -> { admin_email }, from: -> { admin_email }

  def new_application
    @application = params[:application]
    @job = @application.job
    mail(subject: "Nouvelle candidature - #{@job.title}")
  end

  private

  def admin_email
    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
