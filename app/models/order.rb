class Order < ActiveRecord::Base
  # ASSOCIATIONS --------------------------------------------------------

  has_many :order_items
  # rich on rails before helpers
  before_create :set_order_status
  before_save :update_subtotal

  # VALIDATIONS ----------------------------------------------------------

  # validates :buyer_name, presence: true
  # validates :buyer_email, {presence: true}
  # validates :buyer_address, presence: true
  # validates :buyer_zip, presence: true,
  #                       numericality: { only_integer: true },
  #                       length: { minimum: 5 }
  # validates :buyer_state, presence: true,
  #                         length: { is: 2 }
  # validates :buyer_city, presence: true
  # validates :buyer_expcc, presence: true
  # validates :buyer_last4cc, presence: true,
  #                           numericality: { only_integer: true },
  #                           length: { is: 4 }

  # validate :email_must_contain_at

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

private

    def set_order_status
      self.status = "pending"
    end

    def update_subtotal
      self[:subtotal] = subtotal
    end

    def email_must_contain_at
      return if self.buyer_email == nil # guard clause, inline conditional
      unless self.buyer_email.chars.include?("@")
        # refactor to include regex
        errors.add(:buyer_email, "Invalid email. Please enter a correct email address.")
      end
    end
    
end
