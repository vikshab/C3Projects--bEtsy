class CategoriesController < ApplicationController
  before_action :category_exist?, only: [:show]
  before_action :require_login, only: [:new, :create]

  def show
    @category = Category.find_by(name: params[:category_name])
    @products = @category.products.active_product
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to :back
    else
      render 'new'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def category_exist?
    if Category.where(name: params["category_name"]).any?
      show
    else
      flash[:error] = "This category does not exist"
      redirect_to root_path
    end
  end
end
