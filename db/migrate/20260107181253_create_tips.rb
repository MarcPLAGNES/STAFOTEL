class CreateTips < ActiveRecord::Migration[7.1]
  def change
    create_table :tips do |t|
      t.string :title
      t.string :intro
      t.text :description
      t.string :image
      t.text :tips

      t.timestamps
    end
  end
end
