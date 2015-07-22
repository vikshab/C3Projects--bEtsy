class WelcomeController < ApplicationController
  def index
    @top_products = Product.top_products
  end
end
