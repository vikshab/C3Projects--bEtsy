class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]

  def add_to_cart
    OrderItem.create(product_id: @product.id, order_id: session[:order_id], quantity_ordered: 1)

    redirect_to cart_path
  end

  def index
    @products = Product.all
  end

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
