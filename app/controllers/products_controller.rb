class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]

  def index
    @products = Product.all
  end

  def show
    @reviews = @product.reviews
    @average_rating = @product.average_rating
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
