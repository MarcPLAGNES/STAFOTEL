class QuotesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :update_status]
  before_action :set_quote, only: [:show, :update_status]
  before_action :authorize_quote_owner!, only: [:show, :update_status]

  def index
    # L'utilisateur ne voit QUE ses propres devis
    @quotes = current_user.quotes
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

    # Créer ou trouver le contact
    @contact = Contact.find_or_initialize_by(
      email: quote_input[:contact_email],
      user: current_user
    )
    @contact.assign_attributes(
      firstname: quote_input[:contact_firstname],
      lastname: quote_input[:contact_lastname],
      phone: quote_input[:contact_phone]
    )

    unless @contact.save
      respond_to do |format|
        format.html { redirect_to root_path, alert: @contact.errors.full_messages.to_sentence }
        format.json { render json: { errors: @contact.errors }, status: :unprocessable_entity }
      end
      return
    end

    # Créer le devis avec le contact et status par défaut
    @quote = Quote.new(quote_params)
    @quote.contact = @contact
    @quote.status = "pending"

    if @quote.save
      begin
        QuoteSubmissionMailer.with(quote: @quote).new_quote.deliver_now
      rescue StandardError => e
        Rails.logger.error("Quote mail delivery failed for quote ##{@quote.id}: #{e.class} - #{e.message}")
      end

      respond_to do |format|
        format.html { redirect_to root_path, notice: "Devis créé." }
        format.json { render json: @quote, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @quote.errors.full_messages.to_sentence }
        format.json { render json: { errors: @quote.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to quotes_path, alert: "Devis introuvable."
  end

  def authorize_quote_owner!
    # Vérifier que le contact du devis appartient à l'utilisateur
    unless @quote.contact.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à ce devis."
    end
  end

  def quote_params
    params.require(:quote).permit(:message, :service_id, :duration)
  end
end
