require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  before :each do
    @seller = Seller.new(username: "a", email: "bob@bob.bob")
    @seller.password = @seller.password_confirmation = "password"
    @seller.save
    @product = Product.create(name: "a", price: 1, seller_id: 1, stock: 5)
    @order = Order.create
    @item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
  end

  describe "database relationships" do
    it "belongs to an order" do
      expect(@item.order).to eq(@order)
    end

    it "belongs to a product" do
      expect(@item.product).to eq(@product)
    end

    it "has a seller through its product" do
      expect(@item.seller.id).to eq(@seller.id)
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

        product.remove_stock!(current_stock)

        invalid_item = OrderItem.create(product_id: product.id, order_id: order2.id, quantity_ordered: 1)
        expect(invalid_item.id).to be(nil)
      end

      it "is not valid if product is already part of order" do
        order = Order.create
        product = Product.create(name: "blabbasdk4t3ny9", stock: 50, price: 1, seller_id: 1)

        valid_item = OrderItem.new(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        expect(valid_item).to be_valid

        OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)

        invalid_item = OrderItem.new(order_id: order.id, product_id: product.id, quantity_ordered: 1)
        invalid_item.valid?
        expect(valid_item).not_to be_valid
        expect(invalid_item.errors).to include(:product_not_unique)
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

    context "#more!" do
      it "increments the quantity_ordered" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        item.more!
        expect(item.quantity_ordered).to eq(2)
      end

      it "unless that quantity is beyond the stock available" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 5)
        item.more!
        expect(item.quantity_ordered).to eq(5)
        expect(item.errors.keys).to include(:product_stock)
      end
    end

    context "#less!" do
      it "decrements the quantity_ordered" do
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

    context "#total_item_price" do
      it "has a price through its association to product" do
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        expect(item.total_item_price).to eq(@product.price)
      end

      it "has a price that adjusts based on quantity_ordered" do
        quantity = 2
        item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: quantity)
        expect(item.total_item_price).to eq(@product.price * quantity)
      end
    end

    context "#adjust_if_product_stock_changed!" do
      it "reduces the quantity ordered if product has less stock" do
        product = Product.create(name: 'asdafun94ymc34', price: 1, seller_id: 1, stock: 1)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 10)
        item.adjust_if_product_stock_changed!

        expect(item.quantity_ordered).to eq(1)
        expect(item.errors.keys).to include(:product_stock)
      end

      it "doesn't reduce the quantity if product has enough stock" do
        product = Product.create(name: 'a34m89yv39ampy', price: 1, seller_id: 1, stock: 100)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 10)
        item.adjust_if_product_stock_changed!

        expect(item.quantity_ordered).to eq(10)
        expect(item.errors.keys).not_to include(:product_stock)
      end
    end

    context "#remove_product_stock!" do
      it "reduces the product's stock by the item's quantity_ordered" do
        product = Product.create(name: 'a34m89yv39am765rfvg', price: 1, seller_id: 1, stock: 100)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 10)
        item.remove_product_stock!

        product.reload
        expect(product.stock).to eq(90)
      end
    end

    context "#order_item_is_unique?" do
      pending "order_item_is_unique? needs specs"
    end

    context "#product_has_stock?" do
      it "returns true if product.stock is a positive number" do
        product = Product.create(name: 'a34m89yv39ampy', price: 1, seller_id: 1, stock: 100)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 1)

        expect(item.product_has_stock?).to eq(true)
      end

      it "returns false if product.stock is not a positive number" do
        product = Product.create(name: 'a34m89yv39ampy', price: 1, seller_id: 1, stock: 0)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 1)

        expect(item.product_has_stock?).to eq(false)
      end
    end

    context "#quantity_too_high?" do
        # quantity_ordered >= product.stock
      it "returns true if quantity_ordered is greater than or equal to product stock" do
        product = Product.create(name: 'a34m89yv39ampy', price: 1, seller_id: 1, stock: 0)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 10)

        expect(item.quantity_too_high?).to be(true)
      end

      it "returns false if quantity_ordered is less than product stock" do
        product = Product.create(name: 'a34m89yv39ampy', price: 1, seller_id: 1, stock: 12)
        order = Order.create
        item = OrderItem.create(product_id: product.id, order_id: order.id, quantity_ordered: 10)

        expect(item.quantity_too_high?).to be(false)
      end
    end
  end
end
