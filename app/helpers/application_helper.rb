module ApplicationHelper

  def render_stars(rating)
    output = ''
    if (1..5).include?(rating)
      rating.times { output += image_tag('star.png') }
    end
    output.html_safe
  end

  def avg_rating(product_id)
    ratings = Review.where(product_id: product_id).pluck(:rating)
    # protects for divide by 0
    ratings.size == 0 ? 0 : ratings.sum / ratings.size
  end

  # used in user_controller private method
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_user?(user)
    user == current_user
  end

  # log-in a newly created user
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
   current_user != nil
  end

  def transaction
    order = Order.find(session[:order_id])
    @order_items = OrderItem.where("order_id = ?", params[:order_id])
    total = order.subtotal
    @order_items.each do |item|
      bought = item.quantity #how many were bought
      product = item.product
      inventory = item.product.stock #inventory
      inventory = inventory - bought
      product.update(stock: inventory)
      item.update(status: 'paid')
    end

    order.update(status: "paid")
    session[:order_id] = nil
  end

end
