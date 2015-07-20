class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(name: params[:category_name])
    @products = @category.products
  end

end
