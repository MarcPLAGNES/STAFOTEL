class PagesController < ApplicationController
  def home
    @job1 = Job.first
    @job2 = Job.offset(1).first
    @job3 = Job.offset(2).first
    @job4 = Job.offset(3).first
    @services = Service.all
  end

  def jobs
    @jobs = Job.all
  end

  def tips
    @tips = Tip.all
  end

  def company
  end
end
