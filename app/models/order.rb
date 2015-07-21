class Order < ActiveRecord::Base
  before_save :buyer_card_unexpired? # this should return false if the card is expired.

  attr_accessor :confirmed_payment

  def initialize
    super
    confirmed_payment = false
  end

  # DB relationships
  has_many :order_items, dependent: :destroy
  # should destroy all of the associated OrderItems if an Order is destroyed.
  # TODO: but do we want to destroy Orders?
  has_many :products, through: :order_items


  # validations helper regex
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_BUYER_CARD_SHORT_REGEX = /\A\d{4}\z/

  # data validations
  validates :status, presence: true, inclusion: { in: %w(pending paid complete canceled),
    message: "%{value} is not a valid status" }

  with_options unless: :pending? do
    validates_presence_of :buyer_email
    validates_format_of :buyer_email, with: VALID_EMAIL_REGEX

    # TODO: should we validate buyer name & address any futher?
    validates_presence_of :buyer_name
    validates_presence_of :buyer_address

    validates_presence_of :buyer_card_short
    validates_format_of :buyer_card_short, with: VALID_BUYER_CARD_SHORT_REGEX

    validates_presence_of :buyer_card_expiration
  end
end

  # TODO: validate card expiration is after today / Date.now
  # guard clause that validation should only run if status pending


  def order_price
    # TODO: come back and talk about the method names
    # but fwiw Order.price makes sense to me. more detailed explanation in Orderitem model. -J
    array_of_totals = order_items.map { |item| item.item_price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end

  def already_has_product?(product)
    products.include? product
  end

  def buyer_card_unexpired?
    unexpired = true

    unless pending? && confirmed_payment
      unexpired = buyer_card_expiration > Date.now

      if unexpired
        confirmed_payment = true
      else
        errors[:buyer_card_expiration] = "Card expiration date is not valid."
      end
    end

    return unexpired
  end

  def mutable?
    status == "pending"
  end

  # for validations, update other code to use this instead of mutable.
  def pending?
    status == "pending"
  end
end
