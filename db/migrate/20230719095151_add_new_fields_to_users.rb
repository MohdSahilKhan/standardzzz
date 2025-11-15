class AddNewFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :mobile_number, :string
    add_column :users, :gender, :string  
    add_column :users, :address, :string  
    add_column :users, :city, :string  
    add_column :users, :state, :string  
    add_column :users, :pincode, :string  
    add_column :users, :is_active, :boolean, default: false

    add_index :users, :mobile_number, unique: true

  end
end
