module Products
  class OrdersController < BaseController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!

    def place_order
      cart_items = CartItem.where(user: @current_user)
      if cart_items.empty?
        return render json: { error: "Cart is empty" }, status: :unprocessable_entity
      end
      total = cart_items.sum { |i| i.product.price * i.quantity }
      order = Order.create!(
        user: @current_user,
        total_price: total,
        status: "placed"
      )

      cart_items.each do |item|
        OrderItem.create!(
          order: order,
          product: item.product,
          quantity: item.quantity,
          price: item.product.price,
          color: item.color,
          size: item.size
        )
      end

      cart_items.destroy_all
      render json: order.as_json(include: :order_items), status: :created
    end

    def buy_now
      product = Product.find_by(id: params[:product_id])
      return render json: { error: "Product not found" }, status: :not_found unless product

      quantity = params[:quantity].to_i
      quantity = 1 if quantity <= 0

      color = params[:color]
      size = params[:size]

      total_price = product.price * quantity

      order = Order.create!(
        user: @current_user,
        total_price: total_price,
        status: "placed"
      )
      OrderItem.create!(
        order: order,
        product: product,
        quantity: quantity,
        price: product.price,
        color: color,
        size: size
      )

      render json: order.as_json(include: :order_items), status: :created
    end

    def user_orders
      orders = @current_user.orders.includes(:order_items)
      render json: orders.as_json(include: :order_items)
    end
  end
end
