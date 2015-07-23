class CategoriesController < ApplicationController
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
end
