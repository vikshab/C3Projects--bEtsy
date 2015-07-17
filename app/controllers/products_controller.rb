class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]

  def add_to_cart
    session[:order_id] ||= Order.create.id

    # this should perhaps be a method in the order model
    unless Order.find(session[:order_id]).already_has_product?(@product.id)
      OrderItem.create(product_id: @product.id, order_id: session[:order_id], quantity_ordered: 1)
    end

    redirect_to cart_path # this should redirect to product show page
  end

  def index
    @products = Product.all
  end

  def show
    @reviews = Product.find(params[:id]).reviews
    @average_rating = Product.average_rating(params[:id])
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
