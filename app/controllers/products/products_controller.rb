module Products
  class ProductsController < ApplicationController
    before_action :set_product, only: [:show, :update, :destroy]
    skip_before_action :verify_authenticity_token

    def index
      products = Product.order(id: :desc)
      render json: products_with_images(products)
    end

    def show
      render json: product_with_images(@product)
    end

    def create
      product = Product.new(product_params)
      if params[:images]
        params[:images].each do |img|
          product.images.attach(img)
        end
      end

      if product.save
        render json: product_with_images(product), status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        if params[:images]
          params[:images].each do |img|
            @product.images.attach(img)
          end
        end
        render json: product_with_images(@product)
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      render json: { message: "Product deleted" }
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name,
        :price,
        :stock,
        description: [],
        colour: [],
        size: []
      )
    end

    def product_with_images(product)
      product.as_json.merge(
        images: product.images.map { |img| img.service_url(expires_in: 7.day, disposition: "inline") }
      )
    end

    def products_with_images(products)
      products.map { |p| product_with_images(p) }
    end
  end
end
