class QuotesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :update_status, :destroy]
  before_action :set_quote, only: [:show, :update_status, :destroy]
  before_action :authorize_quote_owner!, only: [:show, :update_status, :destroy]

  def index
    if current_user.admin?
      @quotes = Quote
        .includes(:service, :contact)
        .joins(:contact)
        .where("contacts.user_id IS NULL OR contacts.user_id != ?", current_user.id)
        .order(created_at: :desc)
    else
      # L'utilisateur ne voit QUE ses propres devis
      @quotes = current_user.quotes.order(created_at: :desc)
    end
  end

  def show
    # @quote déjà défini par before_action
  end

  def new
    @service = Service.find(params[:service_id])
    @quote = Quote.new(service: @service)
  end

  def update_status
    # Seuls les statuts autorisés
    allowed_statuses = ['pending', 'accepted', 'refused']
    new_status = params[:quote][:status]

    unless allowed_statuses.include?(new_status)
      redirect_to @quote, alert: "Statut non autorisé." and return
    end

    if @quote.update(status: new_status)
      redirect_to @quote, notice: "Statut du devis mis à jour."
    else
      redirect_to @quote, alert: "Erreur lors de la mise à jour."
    end
  end

  def create
    quote_input = params.require(:quote)
    normalized_email = quote_input[:contact_email].to_s.strip.downcase

    # Réutiliser un contact existant (même email), sinon en créer un nouveau.
    # Le fallback Ruby couvre les emails historiques mal normalisés en base.
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
        firstname: quote_input[:contact_firstname].presence || @contact.firstname,
        lastname: quote_input[:contact_lastname].presence || @contact.lastname,
        phone: quote_input[:contact_phone].presence || @contact.phone
      )

      unless @contact.save
        respond_to do |format|
          format.html { redirect_to root_path, alert: @contact.errors.full_messages.to_sentence }
          format.json { render json: { errors: @contact.errors }, status: :unprocessable_entity }
        end
        return
      end
    else
      @contact = Contact.new(
        user: current_user,
        email: normalized_email,
        firstname: quote_input[:contact_firstname],
        lastname: quote_input[:contact_lastname],
        phone: quote_input[:contact_phone]
      )

      begin
        contact_saved = @contact.save
      rescue ActiveRecord::RecordNotUnique
        contact_saved = false
        @contact.errors.add(:email, :taken)
      end

      unless contact_saved
        if @contact.errors.added?(:email, :taken)
          existing_contact = Contact.where(user: current_user).find do |contact|
            contact.email.to_s.strip.downcase == normalized_email
          end

          if existing_contact.present?
            @contact = existing_contact
          else
            respond_to do |format|
              format.html { redirect_to root_path, alert: @contact.errors.full_messages.to_sentence }
              format.json { render json: { errors: @contact.errors }, status: :unprocessable_entity }
            end
            return
          end
        else
          respond_to do |format|
            format.html { redirect_to root_path, alert: @contact.errors.full_messages.to_sentence }
            format.json { render json: { errors: @contact.errors }, status: :unprocessable_entity }
          end
          return
        end
      end

      if @contact.nil?
        respond_to do |format|
          format.html { redirect_to root_path, alert: "Impossible de retrouver un contact valide pour cet email." }
          format.json { render json: { errors: ["Impossible de retrouver un contact valide pour cet email."] }, status: :unprocessable_entity }
        end
        return
      end
    end

    # Créer le devis avec le contact et status par défaut
    @quote = Quote.new(quote_params)
    @quote.contact = @contact
    @quote.status = "pending"

    if @quote.save
      mail_delivery_failed = false

      begin
        QuoteSubmissionMailer.with(quote: @quote).new_quote.deliver_now
      rescue StandardError => e
        mail_delivery_failed = true
        Rails.logger.error("Quote mail delivery failed for quote ##{@quote.id}: #{e.class} - #{e.message}")
      end

      respond_to do |format|
        format.html do
          if mail_delivery_failed
            redirect_to root_path, alert: "Devis créé, mais l'envoi email a échoué. Merci de nous contacter directement à qualite@stafotel.com."
          else
            redirect_to root_path, notice: "Devis créé."
          end
        end
        format.json { render json: @quote, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @quote.errors.full_messages.to_sentence }
        format.json { render json: { errors: @quote.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    unless current_user.admin?
      redirect_to quotes_path, alert: "Action non autorisée."
      return
    end

    @quote.destroy
    redirect_to quotes_path, notice: "Demande de devis supprimée."
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to quotes_path, alert: "Devis introuvable."
  end

  def authorize_quote_owner!
    return if current_user.admin?

    # Vérifier que le contact du devis appartient à l'utilisateur
    unless @quote.contact.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à ce devis."
    end
  end

  def quote_params
    params.require(:quote).permit(:message, :service_id, :duration)
  end
end
