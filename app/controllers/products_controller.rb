class ProductsController < ApplicationController
  # before_action :require_login, except: [:index, :show]

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
    @product = Product.new(user_params[:product])

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
      redirect_to user_path(@product.user_id)
    else
      render :edit
    end
  end


  def destroy
    show
    @product.destroy

    redirect_to products_path
  end

  def retire
    @product = Product.find(params[:id])
    @product.retire_product
    @product.save
    redirect_to user_path(@product.user_id)
  end


  private

  def user_params
    params.permit(product: [:name, :price, :desc, :stock, :photo_url, :user_id, :retired])
  end

end
