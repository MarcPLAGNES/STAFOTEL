class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :date
      t.string :status
      t.references :contact, null: false, foreign_key: true
      t.references :quote, null: false, foreign_key: true

      t.timestamps
    end
  end
end
