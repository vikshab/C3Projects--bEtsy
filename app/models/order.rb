class Order < ActiveRecord::Base
  # DB relationships
  has_many :order_items, dependent: :destroy
  # should destroy all of the associated OrderItems if an Order is destroyed.
  # we can use this as part of the cleaning task we set up to kill any pending
  # orders inactive for whatever time we set.
  # (20-30 minutes? a day? anything inactive for over 2hrs, but only run task once a day?)
  has_many :products, through: :order_items
  has_many :sellers, through: :products


  # validations helper regex
  # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_STATUS_REGEX = /(pending)|(paid)|(complete)|(cancelled)/

  # data validations
  validates :status, presence: true, format: { with: VALID_STATUS_REGEX }

  validates_presence_of :buyer_email, unless: :pending?
  validates_format_of :buyer_email, with: VALID_EMAIL_REGEX, unless: :pending?

  validates_presence_of :buyer_name, unless: :pending?
  validates_presence_of :buyer_address, unless: :pending?
  # !W !Q TODO: validate address or name somehow?

  validates_presence_of :buyer_card_short, unless: :pending?
  validates_numericality_of :buyer_card_short, only_integer: true, greater_than: 999, less_than: 10_000, unless: :pending?

  validates_presence_of :buyer_card_expiration, unless: :pending?
  # !W TODO: validate card expiration is after today / Date.now


  def order_price
    # come back and talk about the method names
    # but fwiw Order.price makes sense to me. more detailed explanation in Orderitem model. -J
    array_of_totals = order_items.map { |item| item.item_price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end

  def already_has_product?(product)
    products.include? product
  end

  def mutable?
    status == "pending"
  end

  # for validations, update other code to use this instead of mutable.
  def pending?
    status == "pending"
  end
end
