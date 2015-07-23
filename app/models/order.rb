class Order < ActiveRecord::Base
  attr_accessor :confirmed_payment

  after_initialize do |order|
    order.confirmed_payment = false
  end

  # DB relationships
  has_many :order_items, dependent: :destroy
  # should destroy all of the associated OrderItems if an Order is destroyed.
  # TODO: but do we want to destroy Orders?
  has_many :products, through: :order_items


  # validations helper regex
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_BUYER_CARD_SHORT_REGEX = /\A\d{4}\z/

  # data validations
  validates :status, presence: true, inclusion: { in: %w(pending paid complete canceled),
    message: "%{value} is not a valid status" }

  with_options unless: :pending? do
    validates_presence_of :buyer_email
    validates_format_of :buyer_email, with: VALID_EMAIL_REGEX

    validates_presence_of :buyer_name
    validates_presence_of :buyer_address

    validates_presence_of :buyer_card_short
    validates_format_of :buyer_card_short, with: VALID_BUYER_CARD_SHORT_REGEX

    validates_presence_of :buyer_card_expiration
    validate :buyer_card_unexpired
  end

  def total_order_price(seller_id=nil)
    items = seller_id ? order_items.select{ |item| item.seller.id == seller_id } : order_items
    array_of_totals = items.map { |item| item.total_item_price }
    total = array_of_totals.sum
  end

  def already_has_product?(product)
    products.include? product
  end

  def buyer_card_unexpired
    # guard clause that works with the setup on lines 2 - 6
    return if confirmed_payment
    # if order is not pending and payment has not yet been confirmed,
    # then confirm the payment -- which in this case means check the
    # expiration date is on or after today.

    if buyer_card_expiration && (buyer_card_expiration >= Date.today)
      @confirmed_payment = true
    else
      errors[:buyer_card_expiration] << "Card expiration date is not valid."
    end
  end

  def pending?
    status == "pending"
  end

  def checkout(checkout_params)
    checkout_params[:status] = "paid"
    self.update(checkout_params)
  end
end
