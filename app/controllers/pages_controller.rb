class PagesController < ApplicationController
  def home
    @job1 = Job.first
    @job2 = Job.offset(1).first
    @job3 = Job.offset(2).first
    @job4 = Job.offset(3).first
  end

  def tips
  end

  def company
  end
end
