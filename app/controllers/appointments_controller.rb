class AppointmentsController < ApplicationController
  def create
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Rendez-vous créé." }
        format.json { render json: @appointment, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @appointment.errors.full_messages.to_sentence }
        format.json { render json: { errors: @appointment.errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:date, :status, :contact_id, :quote_id)
  end
end
