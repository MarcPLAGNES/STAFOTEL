class AddFieldsToTips < ActiveRecord::Migration[7.1]
  def change
    add_column :tips, :products, :text
    add_column :tips, :usage, :text
    add_column :tips, :results, :text
  end
end
