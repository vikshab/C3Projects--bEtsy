require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "display_dollars" do
    it "takes in an amount in cents and converts it to dollars" do
      five_dollars_in_cents = 500
      two_hundred_dollars_in_cents = 20_000
      fourteen_seventy_five = 1475

      expect(display_dollars(five_dollars_in_cents)).to eq("$5.00")
      expect(display_dollars(fourteen_seventy_five)).to eq("$14.75")
      expect(display_dollars(two_hundred_dollars_in_cents)).to eq("$200.00")
    end
  end

  describe "cart_display_text" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id
      @product = Product.create(name: "Blaster", price: 1, seller_id: 1, stock: 5)
    end

    it "lovingly crafts the cart display text" do
      expect(cart_display_text).to eq("Cart")
    end

    it "and adds ' (n)' when n > 0 for # of items in the cart" do
      OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
      expect(cart_display_text).to eq("Cart (1)")

      product = Product.create(name: "Blast From The Past", price: 1, seller_id: 1, stock: 5)
      OrderItem.create(product_id: product.id, order_id: @order.id, quantity_ordered: 1)
      expect(cart_display_text).to eq("Cart (2)")
    end
  end

  describe "product_short_description" do
    it "truncates a product's description" do
      long_version = <<LONG
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id ex massa.
Nam ornare sagittis efficitur. Aenean leo lectus, bibendum quis eleifend ut,
sodales eget justo. Quisque scelerisque in nisl eu ultricies. Morbi in tortor
nibh. Curabitur quis tristique metus. Pellentesque commodo, eros vitae auctor
pellentesque, leo est laoreet est, sit amet sodales diam mi eu nulla. Etiam at
tempor nibh. Nullam consequat vel ex sed euismod. In id suscipit turpis, eu
condimentum diam. Mauris neque ex, elementum ac velit a, suscipit tempus eros.
Suspendisse augue odio, tincidunt ac lobortis eu, sodales sed dolor. Proin
condimentum risus diam, sed laoreet sem iaculis sit amet.

Praesent sed sem faucibus, aliquet tellus eu, lacinia lorem. Ut est ex,
vestibulum vel est vitae, pulvinar rhoncus lorem. Praesent finibus diam id
iaculis egestas. Aliquam non posuere purus. Donec eu orci diam. Nulla lobortis
metus augue, nec faucibus lacus finibus ut. Vivamus non massa eleifend,
facilisis felis eget, blandit neque. Curabitur non justo suscipit, suscipit erat
ut, pharetra nulla. Nulla dapibus sed elit blandit interdum.
LONG
      short_version = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
      short_version += " Phasellus id ex massa.\nNam ornare sagittis efficitur."
      short_version += " Aenean leo lectus, bibendum quis eleifen..."

      product = Product.create(
        name: "The Adventures of Run-on Sentence Man", price: 1, seller_id: 1,
        stock: 1, description: long_version
      )

      expect(product_short_description(product)).to eq(short_version)
    end

    it "returns nothing if a product has no description" do
      product = Product.create(name: "The Adventures of Run-on Sentence Man",
        price: 1, seller_id: 1, stock: 1)

      expect(product_short_description(product)).to eq(nil)
    end
  end
end
