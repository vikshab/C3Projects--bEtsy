class Product < ActiveRecord::Base
# VALIDATIONS ------------------------------------------------------------------

 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

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
