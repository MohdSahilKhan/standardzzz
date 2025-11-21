class AddColorAndSizeToCartItem < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :color, :string
    add_column :order_items, :size, :string
  end
end
