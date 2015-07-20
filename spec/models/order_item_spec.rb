require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "database relationships" do
    before :each do
      @product = Product.create(name: "astronaut", price: 4_000, seller_id: 1, stock: 5)
      @order = Order.create
      @item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 1)
    end

    it "belongs to a product" do
      expect(@item.product).to eq(@product)
    end

    it "belongs to an order" do
      expect(@item.order).to eq(@order)
    end
  end

  describe "model validations" do
    context "product_id" do
      it "requires a product_id" do
        valid_item = OrderItem.create(product_id: 1)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must have a numeric value" do
        valid_item = OrderItem.create(product_id: 4000)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: "four thousand")
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be an integer value" do
        valid_item = OrderItem.create(product_id: 4)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: 4.1)
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be greater than zero" do
        valid_item = OrderItem.create(product_id: 4)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: -4)
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid

        also_invalid_item = OrderItem.create(product_id: 0)
        expect(also_invalid_item.errors.keys).to include(:product_id)
        expect(also_invalid_item).to_not be_valid
      end

      it "is not valid if there is no available product stock" do
        product = Product.create(name: "a", price: 1, seller_id: 1, stock: 5)
        order1 = Order.create
        order2 = Order.create
        order3 = Order.create

        item = OrderItem.create(product_id: product.id, order_id: order1.id, quantity_ordered: 4)
        expect(product.has_available_stock?).to be(true)

        valid_item = OrderItem.create(product_id: product.id, order_id: order2.id, quantity_ordered: 1)
        product.reload
        puts valid_item.id
        expect(product.has_available_stock?).to be(false)

        invalid_item = OrderItem.create(product_id: product.id, order_id: order3.id, quantity_ordered: 1)
        product.reload
        puts invalid_item.valid? # this must be because my checks are after validation but before save/create
        puts invalid_item.id.inspect # but it's clearly still not passing
        expect(invalid_item.errors.keys).to include(:quantity_ordered) # so why isn't this there?
        expect(invalid_item.errors.messages).to include("Product must have available stock.")
      end

      it "is not valid if product is already part of order" do
        order = Order.create
        product = Product.create(name: "a", stock: 50, price: 1, seller_id: 1)

        valid_item = OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        expect(valid_item).to be_valid

        invalid_item = OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        expect(invalid_item).to_not be_valid
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item.errors.messages).to include("That product is already part of this order.")
      end
    end

    context "order_id" do
      it "requires a order_id" do
        valid_item = OrderItem.create(order_id: 1)
        expect(valid_item.errors.keys).to_not include(:order_id)

        invalid_item = OrderItem.create
        expect(invalid_item.errors.keys).to include(:order_id)
        expect(invalid_item).to_not be_valid
      end

      it "must have a numeric value" do
        valid_item = OrderItem.create(order_id: 4000)
        expect(valid_item.errors.keys).to_not include(:order_id)

        invalid_item = OrderItem.create(order_id: "four thousand")
        expect(invalid_item.errors.keys).to include(:order_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be an integer value" do
        valid_item = OrderItem.create(order_id: 4)
        expect(valid_item.errors.keys).to_not include(:order_id)

        invalid_item = OrderItem.create(order_id: 4.1)
        expect(invalid_item.errors.keys).to include(:order_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be greater than zero" do
        valid_item = OrderItem.create(order_id: 4)
        expect(valid_item.errors.keys).to_not include(:order_id)

        invalid_item = OrderItem.create(order_id: -4)
        expect(invalid_item.errors.keys).to include(:order_id)
        expect(invalid_item).to_not be_valid

        also_invalid_item = OrderItem.create(order_id: 0)
        expect(also_invalid_item.errors.keys).to include(:order_id)
        expect(also_invalid_item).to_not be_valid
      end
    end

    context "quantity_ordered" do
      it "requires a quantity_ordered" do
        valid_item = OrderItem.create(quantity_ordered: 1)
        expect(valid_item.errors.keys).to_not include(:quantity_ordered)

        invalid_item = OrderItem.create
        expect(invalid_item.errors.keys).to include(:quantity_ordered)
        expect(invalid_item).to_not be_valid
      end

      it "must have a numeric value" do
        valid_item = OrderItem.create(quantity_ordered: 4000)
        expect(valid_item.errors.keys).to_not include(:quantity_ordered)

        invalid_item = OrderItem.create(quantity_ordered: "four thousand")
        expect(invalid_item.errors.keys).to include(:quantity_ordered)
        expect(invalid_item).to_not be_valid
      end

      it "must be an integer value" do
        valid_item = OrderItem.create(quantity_ordered: 4)
        expect(valid_item.errors.keys).to_not include(:quantity_ordered)

        invalid_item = OrderItem.create(quantity_ordered: 4.1)
        expect(invalid_item.errors.keys).to include(:quantity_ordered)
        expect(invalid_item).to_not be_valid
      end

      it "must be greater than zero" do
        valid_item = OrderItem.create(quantity_ordered: 4)
        expect(valid_item.errors.keys).to_not include(:quantity_ordered)

        invalid_item = OrderItem.create(quantity_ordered: -4)
        expect(invalid_item.errors.keys).to include(:quantity_ordered)
        expect(invalid_item).to_not be_valid

        also_invalid_item = OrderItem.create(quantity_ordered: 0)
        expect(also_invalid_item.errors.keys).to include(:quantity_ordered)
        expect(also_invalid_item).to_not be_valid
      end
    end
  end

  describe "methods" do
    before :each do
      @order = Order.create
      @product = Product.create(name: "astronaut", price: 4_000, seller_id: 1, stock: 5)
    end

    context "price" do
      it "has a price through its association to product" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        expect(item.item_price).to eq(@product.price)
      end

      it "has a price that adjusts based on quantity_ordered" do
        quantity = 2
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: quantity)
        expect(item.item_price).to eq(@product.price * quantity)
      end
    end

    context "remove_prompt_text" do
      it "outputs a string related to removing items from the cart" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        remove_string =  "Are you sure you want to remove this item (astronaut) from your cart?"
        expect(item.remove_prompt_text).to eq(remove_string)
      end
    end
  end
end
