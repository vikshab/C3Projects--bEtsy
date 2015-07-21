class Product < ActiveRecord::Base
# VALIDATIONS ------------------------------------------------------------------

 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: { greater_than: 0 }
 validates :user_id, presence: true
 validates :stock, numericality: {greater_than_or_equal_to: 0}

# ASSOCIATIONS -----------------------------------------------------------------

  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items

# SCOPE ------------------------------------------------------------------------

  scope :active_product, -> { where(retired: false) }

  def retire_toggle!
    self.retired ? self.retired = false : self.retired = true
  end
end
