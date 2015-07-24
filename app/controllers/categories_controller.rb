class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :set_seller, only: [:new, :create]
  before_action :require_seller_login, only: [:new, :create]

  def index
    @categories = Category.all.sort_by { |category| category.name }
  end

  def show
    @products = @category.products
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(create_params)
    if @category.save
      session[:seller_id] = @seller.id
      redirect_to seller_products_path(@seller)
    else
      flash.now[:errors] = @category.errors
      render :new
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def create_params
      params.require(:category).permit(:name)
    end
end
