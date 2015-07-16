require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "model validations" do
    context "when name is missing" do
      it "does not persist the record" do
        category = Category.new

        expect(category).to_not be_valid
        expect(category.errors.keys).to include(:name)
      end
    end
  end
end
