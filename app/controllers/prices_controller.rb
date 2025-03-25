require 'net/http'

class PricesController < ApplicationController
  allow_unauthenticated_access

  def fetch_price
    if params[:local]
      price = rand(5.20..5.29).ceil(3)
      price = 5
      last_updated = Time.now
      render json: { price:, last_updated: } and return
    end

    url = URI("https://pro-api.coinmarketcap.com/v1/tools/price-conversion?amount=1&symbol=USDT&convert=SBTC")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-CMC_PRO_API_KEY"] = Settings.coinmarketcap.api_key

    response = http.request(request)

    data = JSON.parse(response.body, symbolize_names: true)

    case data
    in { data: { quote: { SBTC: { price:, last_updated: } } } }
      price = price
      last_updated = last_updated
    else
      price = nil
      last_updated = nil
    end
    render json: { price:, last_updated: }
  end
end
