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

  describe "scopes" do
    context "by_product" do
      # scope :by_product, ->(prod_id) { where(product_id: prod_id) }
      it "order items can grabbed on a product by product basis" do
        no_desired_product = 10
        no_other_product = 40

        no_desired_product.times do
          OrderItem.create(product_id: 1, order_id: (1..4).to_a.sample, quantity_ordered: 5)
        end

        no_other_product.times do
          OrderItem.create(product_id: (2..5).to_a.sample, order_id: (1..4).to_a.sample, quantity_ordered: 5)
        end

        expect(OrderItem.by_product(1).count).to eq(no_desired_product)
        expect(OrderItem.count).to eq(no_desired_product + no_other_product)
      end
    end
  end

  describe "methods" do
    before :each do
      @product = Product.create(name: "astronaut", price: 4_000, seller_id: 1, stock: 5)
    end

    context "price" do
      it "has a price through its association to product" do
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 1)
        expect(item.price).to eq(@product.price)
      end

      it "has a price that adjusts based on quantity_ordered" do
        quantity = 2
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: quantity)
        expect(item.price).to eq(@product.price * quantity)
      end
    end

    context "display_name" do
      it "has a display_name through its association to product" do
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 1)
        expect(item.display_name).to eq(@product.name.capitalize.singularize)
      end

      it "has a display_name that adjusts based on quantity ordered" do
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 2)
        expect(item.display_name).to eq(@product.name.capitalize.pluralize)
      end
    end

    context "remove_prompt_text" do
      it "outputs a string related to removing items from the cart" do
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 1)
        remove_string =  "Are you sure you want to remove this item (1 Astronaut) from your cart?"
        expect(item.remove_prompt_text).to eq(remove_string)
      end

      it "adjusts the string based on quantity ordered" do
        item = OrderItem.create(product_id: 1, order_id: 1, quantity_ordered: 2)
        remove_string =  "Are you sure you want to remove this item (2 Astronauts) from your cart?"
        expect(item.remove_prompt_text).to eq(remove_string)
      end
    end
  end
end
