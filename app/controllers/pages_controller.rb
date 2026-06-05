class PagesController < ApplicationController
  def home
    @meta_title = "Nettoyage professionnel & intérim hôtelier"
    @meta_description = "STAFOTEL accompagne hôtels, bureaux et copropriétés avec des services de nettoyage professionnel et des solutions d'intérim hôtelier fiables et réactives."

    @jobs = Job.order(:id).limit(8).to_a
    @job1, @job2, @job3, @job4, @job5, @job6, @job7, @job8 = @jobs
    @services = Service.all
    @tips = Tip.limit(6)
  end

  def jobs
    @meta_title = "Offres d'emploi hôtellerie et propreté"
    @meta_description = "Découvrez les offres d'emploi STAFOTEL dans l'hôtellerie et le nettoyage professionnel: postes, missions et candidatures en ligne."

    @jobs = Job.all
  end

  def tips
    @meta_title = "Conseils ménage, hôtellerie et propreté"
    @meta_description = "Retrouvez nos conseils pratiques sur l'entretien, l'hygiène et l'organisation du nettoyage pour les professionnels et particuliers."

    @tips = Tip.all
  end

  def company
    @meta_title = "Entreprise de nettoyage et staffing hôtelier"
    @meta_description = "En savoir plus sur STAFOTEL, notre expertise en nettoyage professionnel et en mise à disposition de personnel hôtelier qualifié."
  end

  def privacy
    @meta_title = "Politique de confidentialité"
    @meta_description = "Consultez la politique de confidentialité STAFOTEL et nos engagements sur la protection des données personnelles."

    # Page de politique de confidentialité RGPD
  end

  def sous_traitance
    @meta_title = "Sous-traitance ménage hôtelier"
    @meta_description = "Externalisez vos besoins de ménage hôtelier avec STAFOTEL: équipes formées, continuité de service et qualité opérationnelle."

    # Page expliquant la formule sous-traitance
  end

  def interim
    @meta_title = "Intérim hôtelier pour vos équipes"
    @meta_description = "Renforcez rapidement vos équipes avec notre solution d'intérim hôtelier: personnel qualifié pour le nettoyage des chambres et parties communes."

    # Page expliquant la formule intérim
  end

  def sitemap
    @static_paths = [
      root_path,
      company_path,
      interim_path,
      sous_traitance_path,
      privacy_path,
      contact_path,
      services_path,
      jobs_path,
      tips_path
    ]
    @services = Service.all
    @jobs = Job.all
    @tips = Tip.all
  end
end
