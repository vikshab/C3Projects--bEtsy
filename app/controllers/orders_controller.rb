class OrdersController < ApplicationController
  def add
    # code to add item to the cart
    # some kind of handling for users trying to circumvent assigned id
      # eg, checking for pending status & not allowing any changes otherwise

    if true #success
      # increment cart view
      # redirect_to product page
    else # not success
      # why would it not be successful?
    end
  end

  def cart
    # code to view items in cart
  end

  def checkout
    # code to add buyer info
  end

  def receipt
    # code to display finalized order
  end
end
