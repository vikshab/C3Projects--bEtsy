class Product < ActiveRecord::Base
# Validations ------------------------------------------------------------------
 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

# Assosiations -----------------------------------------------------------------
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
