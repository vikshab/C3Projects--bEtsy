class Product < ActiveRecord::Base
  belongs_to :category_id
  belongs_to :user_id
end
