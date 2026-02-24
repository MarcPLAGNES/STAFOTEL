class TipsController < ApplicationController
  def show
    @tip = Tip.find(params[:id])
    tip_title = @tip.title.presence || "Conseil propreté"
    @meta_title = "#{tip_title}"
    @meta_description = "Lisez notre conseil #{tip_title.downcase} et améliorez vos pratiques de nettoyage et d'organisation."
  end
end
