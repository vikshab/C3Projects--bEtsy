require 'rails_helper'

RSpec.describe User, type: :model do
  describe "model validation" do
    it "requires a name, email and password with matching confirmation to be valid" do
      user = User.new(name: "Frank", email: "name@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")

      expect(user).to be_valid
    end

    it "requires the name to be unique" do
      user1 = User.create(name: "Frank", email: "name@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")
      user2 = User.create(name: "Frank", email: "frank@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")

      expect(user2).to_not be_valid
      expect(user2.errors.keys).to include(:name)
    end

    it "requires the name to be unique, not case-sensitive, FRANK is the same as frank" do
      user1 = User.create(name: "frank", email: "name@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")
      user2 = User.create(name: "FRANK", email: "frank@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")

      expect(user2).to_not be_valid
      expect(user2.errors.keys).to include(:name)
    end

    it "requires the email to be unique" do
      user1 = User.create(name: "Frank", email: "frank@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")
      user2 = User.create(name: "Franklin", email: "frank@email.com", password: "fr@nklin", password_confirmation: "fr@nklin")

      expect(user2).to_not be_valid
      expect(user2.errors.keys).to include(:email)
    end

    it "email needs an @ sign, all the time" do
      user = User.new(name: "Frank", email: "frankmail", password: "fr@nklin", password_confirmation: "fr@nklin")

      expect(user).to_not be_valid
      expect(user.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end

    it "requires the password confirmation to match" do
      user1 = User.create(name: "Frank", email: "frank@email.com", password: "fr@nklin", password_confirmation: "franklin")

      expect(user1).to_not be_valid
      expect(user1.errors.keys).to include(:password_confirmation)
    end

  end
end
