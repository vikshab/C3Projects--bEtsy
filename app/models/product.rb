class Product < ActiveRecord::Base
# Validations___________________________________________________________________
 validates :name, presence: true, uniqueness: true
 validates :price, presence: true, numericality: {only_float: true, greater_than: 0}

# Assosiations__________________________________________________________________
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
