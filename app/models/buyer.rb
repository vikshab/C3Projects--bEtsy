class Buyer < ActiveRecord::Base
  belongs_to :order
end
