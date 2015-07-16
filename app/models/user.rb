class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_many :products
  has_many :order_items, :through => :products
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validate :email_must_contain_at
  has_secure_password
  


  def email_must_contain_at
    return if self.email == nil # guard clause, inline conditional
    unless self.email.chars.include?("@")
      # refactor to include regex
      errors.add(:email, "Invalid email. Please enter a correct email address.")
    end
  end
end
