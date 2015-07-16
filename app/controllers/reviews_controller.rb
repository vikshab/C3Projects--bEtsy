class ReviewsController < ApplicationController

  def new
    @review = Review.new
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.find(params[:id])
    @review = Review.new(create_params)
      if @review.save
        redirect_to product_path(@product)
      else
        render :new
      end
  end

  private

  def create_params
    params[:review].permit(:rating, :description, :product_id)
  end
end
