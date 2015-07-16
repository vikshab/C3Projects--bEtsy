class Order < ActiveRecord::Base
  has_many :order_items

  # VALIDATIONS ------------------------------------------------------------
  validates :buyer_name, presence: true
  validates :buyer_email, presence: true
  validates :buyer_address, presence: true
  validates :buyer_zip, presence: true
  validates :buyer_state, presence: true
  validates :buyer_city, presence: true
  validates :buyer_expcc, presence: true
  validates :buyer_last4cc, presence: true

  # SCOPES ------------------------------------------------------------

end
