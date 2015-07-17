class ReviewsController < ApplicationController
before_action :set_product, only: [:create, :new]
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(create_params)
      if @review.save
        redirect_to product_path(@product)
      else
        render :new
      end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def create_params
    params[:review].permit(:rating, :description, :product_id)
  end
end
