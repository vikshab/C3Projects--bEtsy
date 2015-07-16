class ProductsController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.find(params[:id])

    if @product.save
      redirect_to product_path(@product.id)
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    @product.update(user_params[:product])

    if @product.save
      redirect_to product_path(@product.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:product).permit(:name, :price, :desc, :stock, :photo_url, :category_id, :user_id)
  end

end
