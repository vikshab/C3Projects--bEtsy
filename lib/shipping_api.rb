require "HTTParty"

class ShippingAPI
  SHIPPING_URL = Rails.env.production? ? "PLACEHOLDER" : "http://localhost:3000/shipping/"
  LOGGING_URL  = Rails.env.production? ? "PLACEHOLDER" : "http://localhost:3000/log/"

  def self.call_shipping_api(city, state, zip, country)
    query = "?origin_address1=1215%205th%20Ave&origin_zip=98121&origin_country=US&origin_state=WA&destination_city=#{city}&destination_state=#{state}&destination_zip=#{zip}&destination_country=#{country}"

    ups_response = HTTParty.get(SHIPPING_URL + "ups" + query)
    usps_response = HTTParty.get(SHIPPING_URL + "usps" + query)
    return (ups_response.parsed_response["data"] + usps_response.parsed_response["data"])
  end

  def self.return_info_to_shipping_api(order)
    query = "tux?order=#{order.id}&provider=#{order.shipping_type}&cost=#{order.shipping_price}&estimate=#{order.shipping_estimate}&purchase_time=#{order.updated_at}"

    HTTParty.post(LOGGING_URL + query)
  end
end
