class ContactsController < ApplicationController
  # Protection anti-spam (optionnel: ajouter gem 'rack-attack')

  def new
    @meta_title = "Contact nettoyage et intérim hôtelier"
    @meta_description = "Contactez STAFOTEL pour vos besoins en nettoyage professionnel, sous-traitance ou intérim hôtelier."

    @contact = Contact.new
  end

  def create
    contact_input = contact_params
    normalized_email = contact_input[:email].to_s.strip.downcase

    @contact = Contact
      .where(user: current_user)
      .where("LOWER(TRIM(email)) = ?", normalized_email)
      .first

    if @contact.nil?
      @contact = Contact.where(user: current_user).find do |contact|
        contact.email.to_s.strip.downcase == normalized_email
      end
    end

    if @contact.present?
      @contact.assign_attributes(
        firstname: contact_input[:firstname],
        lastname: contact_input[:lastname],
        phone: contact_input[:phone],
        message: contact_input[:message]
      )
    else
      @contact = Contact.new(contact_input)
      @contact.user = current_user if user_signed_in?
      @contact.email = normalized_email
    end

    if @contact.save
      redirect_to root_path, notice: "Merci pour votre message ! Nous l'avons bien enregistré."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :email, :phone, :message)
  end
end
