class ProductsController < ApplicationController
  before_action :set_product, except: [:index, :new, :create]
  before_action :set_seller, only: [:new, :create]
  before_action :require_seller_login, only: [:new, :update, :edit, :create]

  def index
    @products = Product.all
  end

  def show
    @reviews = @product.reviews
    @average_rating = @product.average_rating
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(create_params)
    @product.seller_id = params[:seller_id]
    if @product.save
      redirect_to product_path(@product)
    else
      render :new
    end
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

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def create_params
    params.require(:product).permit(:name, :price, :stock, :description, :photo_url)
  end
end
