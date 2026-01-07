class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
  end

  def show
    @appointment = Appointment.find(params[:id])
  end

  def reschedule
    @appointment = Appointment.find(params[:id])
    if @appointment.update(date: params[:appointment][:date])
      redirect_to @appointment, notice: "Rendez-vous reprogrammé."
    else
      redirect_to @appointment, alert: "Erreur lors de la reprogrammation."
    end
  end

  def update_status
    @appointment = Appointment.find(params[:id])
    if @appointment.update(status: params[:appointment][:status])
      redirect_to @appointment, notice: "Statut mis à jour."
    else
      redirect_to @appointment, alert: "Erreur lors de la mise à jour."
    end
  end

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
