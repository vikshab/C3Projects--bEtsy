module ApplicationHelper

  def render_stars(rating)
    output = ''
    if (1..5).include?(rating.to_i)
      rating.to_i.times { output += image_tag('star.png') }
    end
    output.html_safe
  end

  def avg_rating(product_id)
    ratings = Review.where(product_id: product_id).pluck(:rating)
    # ratings = product.reviews.pluck(:rating)
    ratings.size == 0 ? 0 : ratings.sum / ratings.size
  end

  # @categories = Category.all
end
