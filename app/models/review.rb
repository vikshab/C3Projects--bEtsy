class Review < ActiveRecord::Base
  # Associations --------------------------------------------------
  belongs_to :product

  # Validations ---------------------------------------------------
  validates :rating, 
            presence: true, 
            numericality: { only_integer: true, 
                            greater_than_or_equal_to: 1, 
                            less_than_or_equal_to: 5 }


  def avg_rating(product_id)
    ratings = Review.where(product_id: product_id).pluck(:rating)
    avg_rating = ratings.sum / ratings.size
  end
end
