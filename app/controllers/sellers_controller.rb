class SellersController < ApplicationController
  def index
    @sellers = Seller.all

    @num_products_for_sellers = hash_of_num_products_for_each_seller(@sellers)
  end

  def show
    @seller = Seller.find(params[:id])
  end

  private

  # these two methods below help calculate a seller's
  # total number of products in stock, we can use methods
  # like these if we want to display other things about
  # the seller on the sellers#index page
  def calculate_num_products(seller)
    num_products = 0
    seller.products.each do |product|
      num_products += product.stock
    end
    return num_products
  end

  def hash_of_num_products_for_each_seller(sellers)
    hash = {}
    sellers.each do |seller|
      hash[seller.id] = calculate_num_products(seller)
    end
    return hash
  end
end
