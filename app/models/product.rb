class Product < ActiveRecord::Base
# Validations___________________________________________________________________
 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: {only_integer: true, greater_than: 0}

# Assosiations__________________________________________________________________
  belongs_to :category
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
