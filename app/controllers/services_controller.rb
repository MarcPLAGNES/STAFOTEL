class ServicesController < ApplicationController
	def index
		@meta_title = "Services de nettoyage professionnel"
		@meta_description = "Explorez les services STAFOTEL pour l'entretien de bureaux, maisons, copropriétés et établissements hôteliers."

		@services = Service.all
	end

	def show
		@service = Service.find(params[:id])
		service_name = @service.name.presence || "Service de nettoyage"
		@meta_title = "#{service_name}"
		@meta_description = "Découvrez notre service #{service_name.downcase} avec STAFOTEL: intervention professionnelle, qualité et réactivité."
	end
end
