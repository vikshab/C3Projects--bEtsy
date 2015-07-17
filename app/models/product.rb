class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :seller
  has_many :order_items
  has_many :reviews

  # Validations ----------------------------------------------------------------
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :seller_id, presence: true, numericality: { only_integer: true }
  validates :stock, presence: true, numericality: { only_integer: true }

  def self.average_rating(id)
    product = Product.find(id)

    rating_total = 0
    total_num_reviews = product.reviews.count

    return "No reviews" if total_num_reviews == 0

    product.reviews.each do |review|
      rating_total += review[:rating]
    end

    average_rating = rating_total/total_num_reviews
    return average_rating
  end
end
