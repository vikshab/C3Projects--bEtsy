class Review < ActiveRecord::Base
  # Associations --------------------------------------------------
  belongs_to :product

  # Validations ---------------------------------------------------
  validates :rating, 
            presence: true, 
            numericality: { only_integer: true, 
                            greater_than_or_equal_to: 1, 
                            less_than_or_equal_to: 5 }
end
