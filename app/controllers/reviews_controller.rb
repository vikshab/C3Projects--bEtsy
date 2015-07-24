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

  def avg_rating(product_id)
    ratings = Review.where(product_id: product_id).pluck(:rating)
    avg_rating = ratings.sum / ratings.size
  end

  private

    def review_params
      params.require(:review).permit(:body, :rating)
    end
end
