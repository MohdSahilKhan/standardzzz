module Products
  class CartController < ApplicationController
    before_action :set_product
    before_action :set_user
    skip_before_action :verify_authenticity_token

    # Add item to cart
    def add
      cart_item = CartItem.find_or_initialize_by(user: @user, product: @product)
      cart_item.quantity += (params[:quantity] || 1).to_i

      if cart_item.save
        render json: cart_item, status: :ok
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # Remove item completely
    def remove
      cart_item = CartItem.find_by(user: @user, product: @product)

      if cart_item
        cart_item.destroy
        render json: { message: "Item removed" }
      else
        render json: { error: "Not in cart" }, status: :not_found
      end
    end

    # View cart
    def show
      items = CartItem.where(user: @user).includes(:product)
      render json: items.as_json(include: :product)
    end

    # Clear cart
    def clear
      CartItem.where(user: @user).destroy_all
      render json: { message: "Cart cleared" }
    end

    private

    def set_product
      @product = Product.find(params[:product_id]) if params[:product_id]
    end

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end