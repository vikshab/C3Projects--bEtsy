class ShippingAPI
  SHIPPING_URL = Rails.env.production? ? "http://safe-beach-7475.herokuapp.com/shipping/" : "http://localhost:3000/shipping/"
  LOGGING_URL  = Rails.env.production? ? "http://safe-beach-7475.herokuapp.com/log/" : "http://localhost:3000/log/"
  TUX_ADDRESS  = "origin_address1=1100%202nd%20Ave&origin_zip=98101&origin_country=US&origin_state=WA"
  TIMED_OUT_ERROR = { timeout: "Timeout occurred, try again later." }
  INVALID_ADDRESS_MESSAGE = "Make sure all fields are valid. State and country must be abbreviated."

  def self.call_shipping_api(city, state, zip, country)
    @query = "?#{TUX_ADDRESS}&destination_city=#{city}&destination_state=#{state}&destination_zip=#{zip}&destination_country=#{country}"

    ups_response = call_api_for("ups")
    return ups_response if timed_out?(ups_response)
    return { ups_response["message"] => INVALID_ADDRESS_MESSAGE } if error_occurred?(ups_response)

    usps_response = call_api_for("usps")
    return usps_response if timed_out?(usps_response)
    return { usps_response["message"] => INVALID_ADDRESS_MESSAGE } if error_occurred?(ups_response)

    return order_by_price(ups_response, usps_response)
  end

  def self.return_info_to_shipping_api(order)
    query = "tux?order_number=#{order.id}&provider=#{order.shipping_type}&cost=#{order.shipping_price}&estimate=#{order.shipping_estimate}&purchase_time=#{order.updated_at}"

    HTTParty.post(LOGGING_URL + query)
  end

  private

  # Why do these methods need to be self methods? That's the only way I could get them to work....
  def self.call_api_for(provider) # provider should be a string
    # Guard for if the request times out.
    begin
      response = HTTParty.get(SHIPPING_URL + provider + @query, timeout: 10)
      return response
    rescue Net::ReadTimeout
      return TIMED_OUT_ERROR
    end
  end

  def self.timed_out?(response)
    response == TIMED_OUT_ERROR ? true : false
  end

  def self.error_occurred?(response)
    response["status"] == "error" ? true : false
  end

  def self.order_by_price(ups_response, usps_response)
    response_combined = ups_response.parsed_response["data"] + usps_response.parsed_response["data"]
    response = response_combined.sort { |x, y| x[1] <=> y[1] }
    return response
  end
end
