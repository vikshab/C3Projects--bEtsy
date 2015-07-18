class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :seller
  # this before_add callback should prevent adding new order_items if stock is effectively zero. -J
  has_many :order_items, before_add: :has_available_stock?
  has_many :reviews

  # Validations ----------------------------------------------------------------
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :seller_id, presence: true, numericality: { only_integer: true }
  validates :stock, presence: true, numericality: { only_integer: true }

  def self.average_rating(id) # why is this a class method instead of an instance method?
    product = Product.find(id) # we could call this on the product in question: product.average_rating -J

    rating_total = 0
    total_num_reviews = product.reviews.count

    return "No reviews" if total_num_reviews == 0

    product.reviews.each do |review|
      rating_total += review[:rating]
    end

    average_rating = rating_total/total_num_reviews
    return average_rating
  end

  def has_available_stock?
    if (quantity_tied_up_in_pending_transactions + 1) <= stock
      return true
    else
      return false
    end
  end

  def update_stock
    # code to reduce stock when order is paid or shipped
    # note: if we go with shipped / complete, the private method
    # quantity_tied_up_in_pending_transactions will need to be updated to
    # account for paid orders as well -J
  end

  private
    def quantity_tied_up_in_pending_transactions
      items_also_pending = order_items.select { |item| item.order.status == "pending" }
      quantity_pending_array = items_also_pending.map { |item| item.quantity_ordered }
      quantity_pending = quantity_pending_array.reduce(0) { |sum, current_quantity| sum += current_quantity }

      return quantity_pending
    end
end
