module Products
  class OrdersController < ApplicationController
    before_action :set_user
    skip_before_action :verify_authenticity_token

    def place
      cart_items = CartItem.where(user: @user)

      if cart_items.empty?
        return render json: { error: "Cart is empty" }, status: :unprocessable_entity
      end

      total = cart_items.sum { |i| i.product.price * i.quantity }

      order = Order.create!(
        user: @user,
        total_price: total,
        status: "placed"
      )

      cart_items.each do |item|
        OrderItem.create!(
          order: order,
          product: item.product,
          quantity: item.quantity,
          price: item.product.price
        )
      end

      cart_items.destroy_all

      render json: order.as_json(include: :order_items), status: :created
    end

    def user_orders
      orders = @user.orders.includes(:order_items)
      render json: orders.as_json(include: :order_items)
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end
  end
end