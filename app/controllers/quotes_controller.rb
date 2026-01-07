class QuotesController < ApplicationController
  def index
    @quotes = Quote.all
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def new
    @service = Service.find(params[:service_id])
    @quote = Quote.new(service: @service)
  end

  def update_status
    @quote = Quote.find(params[:id])
    if @quote.update(status: params[:quote][:status])
      redirect_to @quote, notice: "Statut du devis mis à jour."
    else
      redirect_to @quote, alert: "Erreur lors de la mise à jour."
    end
  end

  def create
    @quote = Quote.new(quote_params)
    if @quote.save
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

  def quote_params
    params.require(:quote).permit(:status, :message, :contact_id, :service_id, :duration)
  end
end
