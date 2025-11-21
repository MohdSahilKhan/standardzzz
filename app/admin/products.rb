ActiveAdmin.register Product do
  permit_params :name, :price, :stock,
                description: [],
                colour: [],
                size: [],
                images: []
  remove_filter :images
  remove_filter :images_attachments
  remove_filter :images_blobs
  remove_filter :cart_items
  remove_filter :order_items
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :price
      f.input :stock

      # tags input (string → split into array)
      f.input :description, as: :tags, collection: f.object.description
      f.input :colour, as: :tags, collection: f.object.colour
      f.input :size, as: :tags, collection: f.object.size

      # ActiveStorage images
      f.input :images, as: :file, input_html: { multiple: true }
    end

    f.actions
  end

  controller do
    # Converts string "a,b,c" → ["a","b","c"]
    def convert_tag_string(params, key)
      return unless params[key].is_a?(String)
      params[key] = params[key].split(",").map(&:strip)
    end

    def create
      convert_tag_string(params[:product], :description)
      convert_tag_string(params[:product], :colour)
      convert_tag_string(params[:product], :size)

      super
    end

    def update
      convert_tag_string(params[:product], :description)
      convert_tag_string(params[:product], :colour)
      convert_tag_string(params[:product], :size)

      super
    end
  end

  show do
    attributes_table do
      row :name
      row :price
      row :stock

      row :description do |product|
        product.description.join(", ")
      end

      row :colour do |product|
        product.colour.join(", ")
      end

      row :size do |product|
        product.size.join(", ")
      end

      row :images do |product|
        ul do
          product.images.each do |img|
            li { image_tag img, width: 100 }
          end
        end
      end
    end
  end
end
