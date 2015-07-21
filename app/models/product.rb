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

  def average_rating
    rating_total = 0.0
    total_num_reviews = self.reviews.count

    return "No reviews" if total_num_reviews == 0

    self.reviews.each do |review|
      rating_total += review[:rating]
    end

    average_rating = (rating_total/total_num_reviews).round(1)
    return average_rating
  end

  def has_available_stock?
    (quantity_tied_up_in_pending_transactions + 1) <= stock
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
