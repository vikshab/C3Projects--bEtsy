require 'rails_helper'

RSpec.describe Cart::OrderItemsController, type: :controller do

  context "updating quantities of items in the cart" do
    it "#less doesn't decrease quantities below one" do
      expect(response).to redirect_to(cart_path)
    end

    it "#more" do
      # patch
      expect(response).to redirect_to(cart_path)
    end
  end
end
