require 'rails_helper'

RSpec.describe ProductsHelper, type: :helper do
  describe "#retire_product_text" do
    it "outputs some text for the retire product button" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      expect(retire_product_text(product)).to eq("Retire this Product")
    end

    it "alters the text based on the product's retired status" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      product.retire!
      expect(retire_product_text(product)).to eq("Reactivate this Product")

      product.retire!
      expect(retire_product_text(product)).to eq("Retire this Product")
    end
  end
end
