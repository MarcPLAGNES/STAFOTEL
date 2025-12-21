class QuotesController < ApplicationController
  def index
    head :ok
  end

  def show
    head :ok
  end

  def new
    @service = Service.find(params[:service_id])
    @quote = Quote.new(service: @service)
  end

  def update_status
    head :ok
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
    params.require(:quote).permit(:status, :message, :contact_id, :service_id)
  end
end
