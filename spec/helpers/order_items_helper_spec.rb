require 'rails_helper'

RSpec.describe OrderItemsHelper, type: :helper do
  describe "remove_prompt_text" do
    it "outputs a string related to removing items from the cart" do
      order = Order.create
      product = Product.create(name: "Blaster", price: 1, seller_id: 1, stock: 5)
      item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 1)
      remove_string =  "Are you sure you want to remove this item (Blaster) from your cart?"
      expect(remove_prompt_text(item)).to eq(remove_string)
    end
  end
end
