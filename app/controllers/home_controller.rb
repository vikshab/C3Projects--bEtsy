class HomeController < ApplicationController

  SAMPLE_SIZE = 6

  def index
    @products = Product.active_product.sample(SAMPLE_SIZE)
    @categories = Category.all
  end
end
