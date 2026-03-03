class ApplicationsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :update_status, :destroy]
  before_action :set_application, only: [:show, :update_status, :destroy]
  before_action :authorize_application_owner!, only: [:show, :update_status, :destroy]

  def index
    if current_user.admin?
      @applications = Application
        .includes(:job, :contact)
        .joins(:contact)
        .where("contacts.user_id IS NULL OR contacts.user_id != ?", current_user.id)
        .order(created_at: :desc)
    else
      # L'utilisateur ne voit QUE ses propres candidatures
      @applications = current_user.applications.order(created_at: :desc)
    end
  end

  def show
    # @application déjà défini
  end

  def new
    @job = Job.find(params[:job_id])
    @application = Application.new(job: @job)
    ensure_admin_contact
    @admin_contact = Contact.find_by(email: admin_email)
  end

  def update_status
    head :ok
  end
  def create
    ensure_admin_contact
    admin_contact = Contact.find_by(email: admin_email)
    @application = Application.new(application_params.merge(contact_id: admin_contact&.id, status: "pending"))
    if @application.save
      ApplicationSubmissionMailer.with(application: @application).new_application.deliver_now
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

  def destroy
    unless current_user.admin?
      redirect_to applications_path, alert: "Action non autorisée."
      return
    end

    @application.destroy
    redirect_to applications_path, notice: "Candidature supprimée."
  end

  private

  def set_application
    @application = Application.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to applications_path, alert: "Candidature introuvable."
  end

  def authorize_application_owner!
    return if current_user.admin?

    unless @application.contact.user == current_user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette candidature."
    end
  end

  def application_params
    # On ne permet PAS de modifier le status directement (seulement l'admin)
    params.require(:application).permit(:message, :contact_id, :job_id)
  end

  def ensure_admin_contact
    Contact.find_or_create_by!(email: admin_email) do |contact|
      contact.firstname = "Admin"
      contact.lastname = "Stafotel"
      contact.phone = "+33000000000"
    end
  end

  def admin_email
    Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "admin@stafotel.com"
  end
end
