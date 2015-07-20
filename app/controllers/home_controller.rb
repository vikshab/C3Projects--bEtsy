class HomeController < ApplicationController
  def index
    @products = Product.all.sample(6)
    @categories = Category.all
  end
end
