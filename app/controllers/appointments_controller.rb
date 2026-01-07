class AppointmentsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :reschedule, :update_status]
  before_action :set_appointment, only: [:show, :reschedule, :update_status]
  before_action :authorize_appointment_owner!, only: [:show, :reschedule, :update_status]

  def index
    # L'utilisateur ne voit QUE ses propres RDV
    @appointments = current_user.appointments
  end

  def show
    # @appointment déjà défini
  end

  def reschedule
    new_date = params[:appointment][:date]

    # Validation: la nouvelle date doit être dans le futur
    if new_date.present? && Date.parse(new_date) < Date.today
      redirect_to @appointment, alert: "La date doit être dans le futur." and return
    end

    if @appointment.update(date: new_date)
      redirect_to @appointment, notice: "Rendez-vous reprogrammé."
    else
      redirect_to @appointment, alert: "Erreur lors de la reprogrammation."
    end
  rescue ArgumentError
    redirect_to @appointment, alert: "Date invalide."
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

  def set_appointment
    @appointment = Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to appointments_path, alert: "Rendez-vous introuvable."
  end

  def authorize_appointment_owner!
    unless @appointment.contact.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à ce rendez-vous."
    end
  end

  def appointment_params
    # Validation stricte des paramètres
    params.require(:appointment).permit(:date, :contact_id, :quote_id)
  end
end
