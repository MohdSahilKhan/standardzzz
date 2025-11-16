class ChangeEmailInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :email, :string, null: true, default: nil
    remove_index :users, :email
  end
end
