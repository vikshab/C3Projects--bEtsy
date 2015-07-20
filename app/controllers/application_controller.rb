class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_categories
  before_action :find_merchants

  def find_categories
    @categories = Category.all
  end

  def find_merchants
    @merchants = User.all
  end
end
