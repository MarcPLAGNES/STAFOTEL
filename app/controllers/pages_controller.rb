class PagesController < ApplicationController
  def home
    @jobs = Job.limit(4).to_a
    @job1, @job2, @job3, @job4 = @jobs
    @services = Service.all
    @tips = Tip.limit(6)
  end

  def jobs
    @jobs = Job.all
  end

  def tips
    @tips = Tip.all
  end

  def company
  end

  def privacy
    # Page de politique de confidentialité RGPD
  end

  def sous_traitance
    # Page expliquant la formule sous-traitance
  end

  def interim
    # Page expliquant la formule intérim
  end
end
