class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :update_status]
  before_action :set_application, only: [:show, :update_status]
  before_action :authorize_application_owner!, only: [:show, :update_status]

  def index
    # L'utilisateur ne voit QUE ses propres candidatures
    @applications = current_user.applications
  end

  def show
    # @application déjà défini
  end

  def new
    @job = Job.find(params[:job_id])
    @application = Application.new(job: @job)
  end

  def update_status
    head :ok
  end
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

  def set_application
    @application = Application.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to applications_path, alert: "Candidature introuvable."
  end

  def authorize_application_owner!
    unless @application.contact.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette candidature."
    end
  end

  def application_params
    # On ne permet PAS de modifier le status directement (seulement l'admin)
    params.require(:application).permit(:message, :contact_id, :job_id)
  end
end
