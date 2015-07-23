require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  describe "updating quantities of items in the cart" do
    let(:initial_quantity) { 3 }
    let(:max_quantity) { 10 }
    let(:test_order) { Order.create(status: "pending") }
    let(:test_product) { Product.create(name: "buttons", seller_id: 1, price: 1_000, stock: max_quantity) }
    let(:test_order_item) { OrderItem.create(order_id: test_order.id, product_id: test_product.id, quantity_ordered: initial_quantity) }

    context "#more: increasing quantity of cart item" do
      it "assigns @order_item" do
        patch :more, id: test_order_item.id

        expect(assigns(:order_item)).to eq(test_order_item)
      end

      it "redirects back to the cart" do
        patch :more, id: test_order_item.id

        expect(response).to redirect_to(cart_path)
        expect(response).to have_http_status(302)
      end

      it "increases the quantity by one" do
        patch :more, id: test_order_item.id

        expect(assigns(:order_item).quantity_ordered).to eq(initial_quantity + 1)
      end

      it "doesn't increase the quantity beyond what's currently in stock" do
        (max_quantity + 1).times do
          patch :more, id: test_order_item.id
        end

        expect(assigns(:order_item).quantity_ordered).to eq(max_quantity)
      end

      it "assigns flash[:errors]" do
        (max_quantity + 1).times do
          patch :more, id: test_order_item.id
        end

        expect(flash[:errors]).to include(:product_stock)
      end
    end

    context "#less: decreasing quantity of cart item" do
      it "assigns @order_item" do
        patch :less, id: test_order_item.id

        expect(assigns(:order_item)).to eq(test_order_item)
      end

      it "redirects back to the cart" do
        patch :less, id: test_order_item.id

        expect(response).to redirect_to(cart_path)
        expect(response).to have_http_status(302)
      end

      it "decreases the quantity by one" do
        patch :less, id: test_order_item.id

        expect(assigns(:order_item).quantity_ordered).to eq(initial_quantity - 1)
      end

      it "doesn't decrease the quantity below one" do
        (initial_quantity + 1).times do
          patch :less, id: test_order_item.id
        end

        expect(assigns(:order_item).quantity_ordered).to eq(1)
      end

      it "assigns flash[:errors]" do
        (initial_quantity + 1).times do
          patch :less, id: test_order_item.id
        end

        expect(flash[:errors]).to include(:quantity_ordered)
      end
    end

    context "#destroy: removing item from cart" do
      it "destroys the item" do
        test_order_item
        expect( OrderItem.find(1) ).to eq(test_order_item)

        delete :destroy, id: test_order_item.id

        expect{ OrderItem.find(1) }.to raise_exception(ActiveRecord::RecordNotFound)
      end

      it "redirects back to the cart" do
        delete :destroy, id: test_order_item.id

        expect(response).to redirect_to(cart_path)
        expect(response).to have_http_status(302)
      end
    end
  end
end
