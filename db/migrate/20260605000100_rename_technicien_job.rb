class RenameTechnicienJob < ActiveRecord::Migration[7.1]
  def up
    job = Job.find_by(title: "Technicien en hôtellerie")
    job&.update!(title: "Technicien polyvalent")
  end

  def down
    job = Job.find_by(title: "Technicien polyvalent")
    job&.update!(title: "Technicien en hôtellerie")
  end
end
