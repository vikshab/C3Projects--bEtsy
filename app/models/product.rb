class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :reviews
  has_many :order_items
end
