class Category < ActiveRecord::Base
  has_and_belongs_to_many :products

  # Validation ------------------------------------------------------------------
  validates :name, presence: true, uniqueness: true

end
