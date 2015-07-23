require 'rails_helper'

RSpec.describe Category, type: :model do

  describe "model validations" do
    it "requires a name all the time" do
      category = Category.new

      expect(category).to_not be_valid
      expect(category.errors.keys).to include(:name)
    end

    it "excludes duplicate names" do
      category1 = Category.create(name: "home")
      category2 = Category.create(name: "home")
      category3 = Category.create(name: "home")

      expect(Category.count).to eq 1
    end
  end
end
