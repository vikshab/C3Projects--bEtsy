class Order < ActiveRecord::Base
  # DB relationships
  has_many :order_items

  # validations helper regex
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_STATUS_REGEX = /(pending)|(paid)|(complete)|(cancelled)/

  # data validations
  validates :status, presence: true, format: { with: VALID_STATUS_REGEX }

  # NOTE: uncommenting the rest of these will break the model validations
  # validates :buyer_card_short, presence: false, numericality: { only_integer: true, greater_than: 999 }
  # validates :buyer_email, presence: false, format: { with: VALID_EMAIL_REGEX }
  # validate card expiration is after today / Date.now
  # validate address or name somehow?

  # scopes
  scope :pending, -> { where(status: "pending") } # rewrite to include product or remove this.

  def price # chg to total_cost
    # come back and talk about the method names.
    array_of_totals = order_items.map { |item| item.price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end

  def already_has_product?(product_id)
    # style thing to talk about explicit vs implicit returns?
    order_items.each do |item|
      return true if item.product_id == product_id
    end

    return false
  end
end
