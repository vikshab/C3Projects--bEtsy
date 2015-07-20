class HomeController < ApplicationController
  def index
    @products = Product.active_product.sample(6)
  end
end
