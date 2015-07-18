class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :create_session

  def create_session
    unless session[:order_id] && Order.find_by(id: session[:order_id])
      order = Order.create
      session[:order_id] = order.id
    end
  end
end
