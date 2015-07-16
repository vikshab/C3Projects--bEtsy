class ReviewsController < ApplicationController
  # Add a review
  def new
    @review = Review.new
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.create(review_params)

    redirect_to product_path(params[:product_id])
   end

  # Delete a review
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  
    redirect_to product_path(params[:product_id])
  end

   private

   def review_params
    params.require(:review).permit(:body, :rating)
   end
end
