require "net/http"

class PricesController < ApplicationController
  allow_unauthenticated_access

  def fetch_price
    result = PriceService.call("USDT", "SBTC")

    render json: result
  end
end
