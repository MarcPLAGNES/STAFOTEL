class JobsController < ApplicationController
	def index
		@meta_title = "Recrutement STAFOTEL"
		@meta_description = "Consultez les opportunités de recrutement STAFOTEL dans le nettoyage professionnel et l'hôtellerie."

		@jobs = Job.all
	end

	def show
		@job = Job.find(params[:id])
		job_title = @job.title.presence || "Offre d'emploi"
		@meta_title = "#{job_title}"
		@meta_description = "Postulez à l'offre #{job_title.downcase} chez STAFOTEL et rejoignez une équipe engagée dans la qualité de service."
	end

	def new
		@meta_title = "Candidature emploi"
		@meta_description = "Déposez votre candidature STAFOTEL pour rejoindre nos équipes en hôtellerie et propreté."

		@job = Job.new
	end

	def create
		@job = Job.new(job_params)
		if @job.save
			redirect_to @job, notice: "Job créé avec succès."
		else
			render :new, status: :unprocessable_entity
		end
	end

	private

	def job_params
		params.require(:job).permit(:title, :description)
	end
end
