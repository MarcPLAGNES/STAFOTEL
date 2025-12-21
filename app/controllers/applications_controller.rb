class ApplicationsController < ApplicationController
  def create
    @application = Application.new(application_params)
    if @application.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Candidature créée." }
        format.json { render json: @application, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @application.errors.full_messages.to_sentence }
        format.json { render json: { errors: @application.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def application_params
    params.require(:application).permit(:status, :message, :contact_id, :job_id)
  end
end
