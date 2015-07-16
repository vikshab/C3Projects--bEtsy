class Order < ActiveRecord::Base
  has_many :order_items

  # VALIDATIONS ------------------------------------------------------------
  validates :buyer_name, presence: true
  validates :buyer_email, presence: true
  validates :buyer_address, presence: true
  validates :buyer_zip, presence: true,
                        numericality: { only_integer: true },
                        length: { minimum: 5 }
  validates :buyer_state, presence: true,
                          length: { is: 2 }
  validates :buyer_city, presence: true
  validates :buyer_expcc, presence: true
  validates :buyer_last4cc, presence: true,
                            numericality: { only_integer: true },
                            length: { is: 4 }

  # custom VALIDATIONS
  # validate :

  # SCOPES ------------------------------------------------------------




end
