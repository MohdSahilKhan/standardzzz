ActiveAdmin.register User do
  # --------------------------------------
  # PERMITTED PARAMETERS
  # --------------------------------------
  permit_params :email, :full_name, :mobile_number, :gender, :address, :city,
                :state, :pincode, :is_active

  # --------------------------------------
  # INDEX PAGE
  # --------------------------------------
  index do
    selectable_column
    id_column
    column :full_name
    column :email
    column :mobile_number
    column :gender
    column :city
    column :state
    column :is_active
    column :created_at
    actions
  end

  # --------------------------------------
  # FILTERS
  # --------------------------------------
  filter :full_name
  filter :email
  filter :mobile_number
  filter :gender, as: :select, collection: ["Male", "Female", "Other"]
  filter :city
  filter :state
  filter :is_active
  filter :created_at

  # --------------------------------------
  # SHOW PAGE
  # --------------------------------------
  show do
    attributes_table do
      row :id
      row :full_name
      row :email
      row :mobile_number
      row :gender
      row :address
      row :city
      row :state
      row :pincode
      row :is_active
      row :created_at
      row :updated_at
    end
  end

  # --------------------------------------
  # FORM
  # --------------------------------------
  form do |f|
    f.inputs "User Details" do
      f.input :full_name
      f.input :email
      f.input :mobile_number
      f.input :gender, as: :select, collection: ["Male", "Female", "Other"]
      f.input :address
      f.input :city
      f.input :state
      f.input :pincode
      f.input :is_active
    end
    f.actions
  end

  # --------------------------------------
  # RANSACK SEARCH ALLOWLIST
  # (Fixes search errors)
  # --------------------------------------
  controller do
    def scoped_collection
      super
    end
  end

end
