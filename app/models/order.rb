class Order < ActiveRecord::Base
  has_many :order_items, dependent: :destroy # should destroy all of the associated OrderItems if an Order is destroyed.
  has_many :products, through: :order_items

  attr_accessor :confirmed_payment

  after_initialize do |order|
    order.confirmed_payment = false
  end

  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_BUYER_CARD_SHORT_REGEX = /\A\d{4}\z/

  validates :status, presence: true, inclusion: { in: %w(pending paid complete canceled),
    message: "%{value} is not a valid status" }

  with_options unless: :pending? do
    before_validation :shorten_credit_card

    validates_presence_of :buyer_email
    validates_format_of :buyer_email, with: VALID_EMAIL_REGEX

    validates_presence_of :buyer_name
    validates_presence_of :buyer_address

    validates_presence_of :buyer_card_short
    validates_format_of :buyer_card_short, with: VALID_BUYER_CARD_SHORT_REGEX

    validates_presence_of :buyer_card_expiration
    validate :buyer_card_unexpired
  end

  def prepare_checkout!
    quantity_ordered_adjusted = false
    order_items.each do |order_item|
      order_item.adjust_if_product_stock_changed!
      quantity_ordered_adjusted = true unless order_item.errors.empty?
    end

    if quantity_ordered_adjusted
      errors[:product_stock] = "Quantity ordered was adjusted because not enough of this product is in stock."
    end
  end

  def checkout!(checkout_params)
    checkout_params[:status] = "paid"
    if update(checkout_params)
      order_items.each do |order_item|
        order_item.remove_product_stock!
        order_item.update(status: "paid")
      end
      return true
    else
      return false
    end
  end

  def total_order_price(seller_id = nil)
    items = seller_id ? order_items.select{ |item| item.seller.id == seller_id } : order_items
    total = items.map { |item| item.total_item_price }.sum
    total += shipping_price
  end

  def already_has_product?(product)
    products.include? product
  end

  def pending?
    status == "pending"
  end

  private
    def shorten_credit_card
      self.buyer_card_short = self.buyer_card_short[-4..-1] if self.buyer_card_short
    end

    def buyer_card_unexpired
      return if confirmed_payment # guard clause that works with the setup on lines 2 - 6

      # if order is not pending and payment has not yet been confirmed,
      # then confirm the card has not expired.
      if buyer_card_expiration && (buyer_card_expiration >= Date.today)
        @confirmed_payment = true
      else
        errors[:buyer_card_expiration] << "date is not valid."
      end
    end
end
