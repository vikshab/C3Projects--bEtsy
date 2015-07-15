class WelcomeController < ApplicationController
  def root
    session[:order_id] ||= Order.create(status: "pending").id
  end
end
