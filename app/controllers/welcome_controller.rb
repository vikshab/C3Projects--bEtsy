class WelcomeController < ApplicationController
  def index
    # # TODO: Jeri, decide if we should keep or delete this
    # session[:order_id] ||= Order.create(status: "pending").id
  end
end
