class Product < ActiveRecord::Base
# Validations ------------------------------------------------------------------
 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

# Associations -----------------------------------------------------------------
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items

  # @products = Product.all
  # @products.each do |product|
  #   @avg_ratings = { product.id => (Review::avg_rating(product.id)) }
  # end

end
