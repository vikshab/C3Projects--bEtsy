class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]

  def index
    @products = Product.all
  end

  def show
    @reviews = @products.reviews
    @average_rating = Product.average_rating(params[:id])
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
