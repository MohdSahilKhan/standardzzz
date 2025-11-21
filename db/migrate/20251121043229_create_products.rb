class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description, array: true, default: []
      t.string :colour, array: true, default: []
      t.string :size, array: true, default: []
      t.decimal :price, precision: 10, scale: 2
      t.boolean :stock, default: true

      t.timestamps
    end
  end
end
