class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :require_seller_login, only: [:new, :create]

  def index
    @categories = Category.all.sort_by { |category| category.name }
  end

  def show
    @products = @category.products.active
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to seller_products_path(session[:seller_id])
    else
      flash.now[:errors] = @category.errors
      render :new
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
