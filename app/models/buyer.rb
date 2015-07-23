class Buyer < ActiveRecord::Base
  belongs_to :order

  # CALLBACK
  after_validation :convert_to_last_four

  # VALIDATIONS ----------------------------------------------------------
  validates :name,        presence: true
  validates :email,       presence: true
  validates :address,     presence: true
  validates :zip,         presence: true,
                          numericality: { only_integer: true },
                          length: { in: 4..5}
  validates :state,       presence: true,
                          length: { is: 2 }
  validates :city,        presence: true
  validates :exp,         presence: true
  validates :credit_card, presence: true,
                          numericality: { only_integer: true },
                          length: { in: 14..16 }

  validate :email_must_contain_at


  private

    def convert_to_last_four
      array = self.credit_card.to_s.split("")
      return self.credit_card unless array.length >= 4
      last_four = array[-4..-1].join.to_i
      self.credit_card = last_four
    end

    def email_must_contain_at
      return if self.email == nil # guard clause, inline conditional
      unless self.email.chars.include?("@")
        # refactor to include regex
        errors.add(:email, "Invalid email. Please enter a correct email address.")
      end
    end
end
