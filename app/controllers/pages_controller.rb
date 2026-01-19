class PagesController < ApplicationController
  def home
    @job1 = Job.first
    @job2 = Job.offset(1).first
    @job3 = Job.offset(2).first
    @job4 = Job.offset(3).first
    @services = Service.all
    @tips = Tip.all.limit(6)
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
