ActiveAdmin.register Order do
  permit_params :user_id, :total_price, :status
  remove_filter :order_items

  filter :user
  filter :total_price
  filter :created_at
  index do
    selectable_column
    id_column
    column :user
    column :total_price
    column :status
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :user
      f.input :total_price
      f.input :status, as: :select, collection: ["placed", "shipped", "delivered", "cancelled"]
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :total_price
      row :status
      row :created_at
      row :updated_at
    end
  end
end
