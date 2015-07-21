class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit]

  def index
    @products = Product.all
  end

  def show
    @reviews = @product.reviews
    @average_rating = @product.average_rating
  end

  def edit; end

  def update
    if @product.update(create_params)
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def create_params
    params.require(:product).permit(:name, :price, :seller_id, :stock, :description, :photo_url)
  end
end
