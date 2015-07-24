require 'rails_helper'

RSpec.describe ProductsHelper, type: :helper do
  describe "#retire_product_text" do
    it "outputs some text for the retire product button" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      expect(retire_product_text(product)).to eq("Retire")
    end

    it "alters the text based on the product's retired status" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      product.retire!
      expect(retire_product_text(product)).to eq("Reactivate")

      product.retire!
      expect(retire_product_text(product)).to eq("Retire")
    end
  end

  describe "#retire_text_short" do
    it "outputs some text for the retire product button" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      expect(retire_text_short(product)).to eq("Retire")
    end

    it "alters the text based on the product's retired status" do
      product = Product.create(name: "asdfasjkhdf", stock: 1, price: 1, seller_id: 1)

      product.retire!
      expect(retire_text_short(product)).to eq("Reactivate")

      product.retire!
      expect(retire_text_short(product)).to eq("Retire")
    end
  end

  describe "#quantity_sold" do
    it "calculates the quantity of of a product actually sold based on order_item qty & order status" do # OPTIMIZE rephrase this?
      checkout_params = { buyer_name: "asdflkasd asdflk asfd", buyer_email: "asdf@eml.net",
        buyer_address: "1234 fake st", buyer_card_expiration: Date.parse("June 5 2086"),
        buyer_card_short: "4567", status: "paid" }
      product = Product.create(name: "asdfasjkhdf", stock: 100, price: 1, seller_id: 1)
      order1 = Order.create
      OrderItem.create(quantity_ordered: 10, product_id: product.id, order_id: order1.id)
      order2 = Order.create(checkout_params)
      OrderItem.create(quantity_ordered: 10, product_id: product.id, order_id: order2.id)

      expect(quantity_sold(product)).to eq(10)
    end
  end
end
