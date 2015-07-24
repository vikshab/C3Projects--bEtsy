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

  # Scopes ---------------------------------------------------------------------
  scope :has_stock, -> { where(retired: false).where("stock > 0") }

  # non-mutative class method

  def self.top_products
    sorted_products = self.has_stock.sort_by { |product| product.average_rating }.reverse!
    top_products = sorted_products.first(12)
  end


  # mutative methods

  def retire!
    update(retired: retired ? false : true)
  end

  def add_stock!(how_much)
    if how_much > 0
      current_stock = stock
      new_stock = current_stock + how_much
      update(stock: new_stock)
    else
      errors[:add_stock] << "You can't add negative or zero stock."
    end
  end

  def remove_stock!(how_much)
    current_stock = stock
    new_stock = current_stock - how_much

    if (how_much > 0) && (new_stock >= 0)
      update(stock: new_stock)
    else
      errors[:remove_stock] << "You can't remove more stock than is present."
    end
  end


  # non-mutative methods

  def average_rating
    total_num_reviews = self.reviews.count
    return 0 if total_num_reviews == 0

    rating_total = 0.0

    reviews.each do |review|
      rating_total += review[:rating]
    end

    average_rating = (rating_total/total_num_reviews).round(1)
    return average_rating
  end

  def stock?
    stock > 0
  end
end
