module Products
  class CartController < BaseController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!
    before_action :set_cart_item, only: [:remove]
    before_action :set_product, only: [:add]
    def add
      cart_item = CartItem.find_by(
        user: current_user,
        product: @product,
        color: params[:color],
        size: params[:size]
      )

      if cart_item
        cart_item.quantity += (params[:quantity] || 1).to_i
      else
        cart_item = CartItem.new(
          user: current_user,
          product: @product,
          color: params[:color],
          size: params[:size],
          quantity: (params[:quantity] || 1).to_i
        )
      end

      if cart_item.save
        render json: cart_item, status: :ok
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def remove
      @cart_item.destroy
      render json: { message: "Item removed" }
    end

    def show
      items = CartItem.where(user: current_user).includes(:product).order(id: :desc)
      render json: items.as_json(include: :product)
    end

    def clear
      CartItem.where(user: current_user).destroy_all
      render json: { message: "Cart cleared" }
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Product not found with ID #{params[:product_id]}" }, status: :not_found
    end

    def set_cart_item
      @cart_item = CartItem.find(params[:cart_item_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Cart item not found with ID" }, status: :not_found
    end
  end
end
