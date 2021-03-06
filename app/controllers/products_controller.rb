class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :retire]
  before_action :set_seller, only: [:new, :create, :seller]
  before_action :require_seller_login, only: [:new, :update, :edit, :create, :add_categories, :retire]

  def index
    @products = Product.active
  end

  def show
    require_seller_login if @product.retired

    @reviews = @product.reviews
    @average_rating = @product.average_rating
    @product_categories = @product.categories
  end

  def new
    @product = Product.new
  end

  def edit
    @categories = Category.all
  end

  def seller; end

  def create
    @product = Product.new(create_params)
    @product.seller_id = params[:seller_id]
    if @product.save
      redirect_to product_path(@product)
    else
      flash.now[:errors] = @product.errors
      render :new
    end
  end

  def update
    if @product.update(create_params)
      redirect_to seller_products_path(@product.seller_id)
    else
      flash.now[:errors] = @product.errors
      render :edit
    end
  end

  def retire
    @product.retire!
    redirect_to product_path(@product)
  end

  def add_categories
    @product = Product.find(params[:product_id])
    params[:category_id].each do |category_id|
      category = Category.find(category_id)
      @product.categories << category
    end
    redirect_to seller_products_path(@product.seller_id)
  end


  private
    def set_product
      @product = Product.find(params[:id])
    end

    def create_params
      params.require(:product).permit(:name, :price, :stock, :description, :photo_url)
    end
end
