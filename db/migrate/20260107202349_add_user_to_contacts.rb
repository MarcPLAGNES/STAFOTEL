class AddUserToContacts < ActiveRecord::Migration[7.1]
  def change
    add_reference :contacts, :user, null: true, foreign_key: true
    add_index :contacts, [:email, :user_id], unique: true
  end
end
