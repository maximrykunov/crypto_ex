FactoryBot.define do
  factory :order do
    user
    order_type { :limit }
    order_side { :exchange }
    base_currency { 'USDT' }
    base_address { SecureRandom.hex }
    quote_currency { 'SBTC' }
    quote_address { SecureRandom.hex }
    amount { 15.505 }
    price { 5.05 }
  end
end
