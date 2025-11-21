ActiveAdmin.register Product do
  permit_params :name, :price, :stock,
                description: [], colour: [], size: []
  remove_filter :cart_items
  remove_filter :order_items

  # (optional) keep only useful filters
  filter :name
  filter :price
  filter :stock
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :colour
    column :size
    column :price
    column :stock
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description, as: :tags, collection: []
      f.input :colour, as: :tags, collection: []
      f.input :size, as: :tags, collection: []
      f.input :price
      f.input :stock
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :colour
      row :size
      row :price
      row :stock
      row :created_at
      row :updated_at
    end
  end
end
