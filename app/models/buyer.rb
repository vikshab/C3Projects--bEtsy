class Buyer < ActiveRecord::Base
  belongs_to :order

  # VALIDATIONS ----------------------------------------------------------
  validates :name,    presence: true
  validates :email,   presence: true
  validates :address, presence: true
  validates :zip,     presence: true,
                      numericality: { only_integer: true },
                      length: { minimum: 5 }
  validates :state,   presence: true,
                      length: { is: 2 }
  validates :city,    presence: true
  validates :expcc,   presence: true
  validates :last4cc, presence: true,
                      numericality: { only_integer: true },
                      length: { is: 4 }

  validate :email_must_contain_at

  private

  def email_must_contain_at
    return if self.email == nil # guard clause, inline conditional
    unless self.email.chars.include?("@")
      # refactor to include regex
      errors.add(:email, "Invalid email. Please enter a correct email address.")
    end
  end

end
