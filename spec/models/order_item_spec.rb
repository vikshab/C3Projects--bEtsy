require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  before :each do
    @product = Product.create(name: "a", price: 1, seller_id: 1, stock: 5)
    @order = Order.create
    @item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 1)
  end

  describe "database relationships" do
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
        valid_item = OrderItem.create(product_id: @product.id)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must have a numeric value" do
        valid_item = OrderItem.create(product_id: 1)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: "four thousand")
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be an integer value" do
        valid_item = OrderItem.create(product_id: @product.id)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: 4.1)
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid
      end

      it "must be greater than zero" do
        valid_item = OrderItem.create(product_id: 1)
        expect(valid_item.errors.keys).to_not include(:product_id)

        invalid_item = OrderItem.create(product_id: -4)
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item).to_not be_valid

        also_invalid_item = OrderItem.create(product_id: 0)
        expect(also_invalid_item.errors.keys).to include(:product_id)
        expect(also_invalid_item).to_not be_valid
      end

      it "is not valid if there is no available product stock" do
        current_stock = 5
        product = Product.create(name: "abbadabbadoo", price: 1, seller_id: 1, stock: current_stock)
        order1 = Order.create
        order2 = Order.create

        valid_item = OrderItem.create(product_id: product.id, order_id: order1.id, quantity_ordered: current_stock)
        expect(valid_item.errors.keys).to_not include(:quantity_ordered)

        invalid_item = OrderItem.create(product_id: product.id, order_id: order2.id, quantity_ordered: 1)
        expect(invalid_item.errors.keys).to include(:quantity_ordered)
        expect(invalid_item.errors[:quantity_ordered]).to include("Product must have available stock.")
      end

      it "is not valid if product is already part of order" do
        order = Order.create
        product = Product.create(name: "blabbasdk4t3ny9", stock: 50, price: 1, seller_id: 1)

        valid_item = OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        expect(valid_item).to be_valid

        invalid_item = OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        expect(invalid_item.errors.keys).to include(:product_id)
        expect(invalid_item.errors[:product_id]).to include("That product is already part of this order.")
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

    context "more!" do
      it "increments the quantity_ordered" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        item.more!
        expect(item.quantity_ordered).to eq(2)
      end

      it "unless that quantity is beyond the stock available" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 5)
        item.more!
        expect(item.quantity_ordered).to eq(5)
        expect(item.errors.keys).to include(:quantity_ordered)
      end
    end

    context "less!" do
      it "increments the quantity_ordered" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 5)
        item.less!
        expect(item.quantity_ordered).to eq(4)
      end

      it "unless that quantity is one or less" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        item.less!
        expect(item.quantity_ordered).to eq(1)
        expect(item.errors.keys).to include(:quantity_ordered)
      end
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
