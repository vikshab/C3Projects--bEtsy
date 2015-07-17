class HomeController < ApplicationController
  def index
    @products = Product.all.sample(6)
  end
end
