class RenameEquipierJob < ActiveRecord::Migration[7.1]
  def up
    job = Job.find_by(title: "Équipier polyvalent en hôtellerie")
    job&.update!(title: "Équipier polyvalent")
  end

  def down
    job = Job.find_by(title: "Équipier polyvalent")
    job&.update!(title: "Équipier polyvalent en hôtellerie")
  end
end
