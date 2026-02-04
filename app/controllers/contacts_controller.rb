class ContactsController < ApplicationController
  # Protection anti-spam (optionnel: ajouter gem 'rack-attack')

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user if user_signed_in?

    if @contact.save
      ContactSubmissionMailer.with(contact: @contact, message: params.dig(:contact, :message)).new_contact.deliver_now
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
end
