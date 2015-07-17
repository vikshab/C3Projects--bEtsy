class Product < ActiveRecord::Base
# Validations___________________________________________________________________
 validates :name, presence: true

# Assosiations__________________________________________________________________
  has_and_belongs_to_many :categories
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
