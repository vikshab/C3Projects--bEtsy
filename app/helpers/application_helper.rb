module ApplicationHelper
  def display_dollars(cents)
    number_to_currency(cents/100.00)
  end
end
