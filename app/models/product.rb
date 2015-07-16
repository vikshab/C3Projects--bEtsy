class Product < ActiveRecord::Base
# Validations___________________________________________________________________
 validates :name, presence: true

# Assosiations__________________________________________________________________
  belongs_to :category
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
