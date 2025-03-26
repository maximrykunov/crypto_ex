require "net/http"

class PriceService < ApplicationService
  attr_reader :symbol, :convert

  def initialize(symbol, convert)
    @symbol = symbol
    @convert = convert
  end

  def call
    return { price: 5.123, last_updated: nil } if Settings.block_price

    url = URI("https://pro-api.coinmarketcap.com/v1/tools/price-conversion?amount=1&symbol=#{symbol}&convert=#{convert}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-CMC_PRO_API_KEY"] = Settings.coinmarketcap.api_key

    response = http.request(request)

    data = JSON.parse(response.body, symbolize_names: true)

    case data
    in { data: { quote: { SBTC: { price:, last_updated: } } } }
      price = price.round(8)
      last_updated = last_updated
    else
      price = nil
      last_updated = nil
    end

    { price:, last_updated: }
  end
end
