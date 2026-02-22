class ContactsController < ApplicationController
  # Protection anti-spam (optionnel: ajouter gem 'rack-attack')

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user if user_signed_in?

    if @contact.save
      ContactSubmissionMailer.with(
        contact: @contact,
        message: params.dig(:contact, :message),
        recipient_email: recipient_email_for_source
      ).new_contact.deliver_now
      # TODO: Envoyer un email de confirmation (avec sanitization)
      redirect_to root_path, notice: "Merci pour votre message ! Nous vous contacterons très prochainement."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :email, :phone)
  end

  def recipient_email_for_source
    source = params[:source].to_s
    return "qualite@stafotel.com" if ["interim", "sous_traitance"].include?(source)

    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
