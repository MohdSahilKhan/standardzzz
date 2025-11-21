ActiveAdmin.register Order do
  # Permit params
  permit_params :user_id, :total_price, :status,
                order_items_attributes: [:id, :product_id, :quantity, :price, :color, :size, :_destroy]

  remove_filter :order_items

  # Filters
  filter :user
  filter :total_price
  filter :created_at

  # Index page
  index do
    selectable_column
    id_column
    column :user
    column :total_price
    column :status
    column :created_at
    column "Items" do |order|
      order.order_items.count # shows number of items in the order
    end
    actions
  end

  # Form for editing/creating orders
  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :total_price
      f.input :status, as: :select, collection: ["placed", "shipped", "delivered", "cancelled"]
    end

    # Nested order items
    f.has_many :order_items, allow_destroy: true, new_record: true do |oi|
      oi.input :product
      oi.input :quantity
      oi.input :price
      oi.input :color
      oi.input :size
    end

    f.actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :user
      row :total_price
      row :status
      row :created_at
      row :updated_at
    end

    # Panel for order items
    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
        column :color
        column :size
      end
    end
  end
end
