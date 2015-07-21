class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_categories
  before_action :find_merchants
  helper_method :current_order
  # helper_method :current_cart

  def find_categories
    @categories = Category.all
  end

  def find_merchants
    @merchants = User.all
  end

  def current_order
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.create
    end
  end

  # def current_cart
  #   if session[:cart_id]
  #     @current_cart ||= Cart.find(session[:cart_id])
  #     session[:cart_id]=nil if @current_cart.purhased_at
  #   end
  #   if session[:cart_id].nil?
  #     @current_cart = Cart.create!
  #     session[:cart_id] = @current.cart.id
  #   end
  #   @current_cart
  # end
end
