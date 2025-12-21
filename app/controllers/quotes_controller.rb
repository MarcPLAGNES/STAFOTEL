class QuotesController < ApplicationController
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
