FactoryBot.define do
  factory :order do
    user
    order_type { :limit }
    order_side { :exchange }
    base_currency { 'USDT' }
    base_address { Settings.usdt_wallet }
    quote_currency { 'SBTC' }
    quote_address { 'bc1qar0srrr8c4xywcrvdp7rkxw7y4f55q9k0pmd4d' }
    send_amount { 15.505 }
    receive_amount { 60.303 }
    fee { 2.01 }
    miner_fee { 0.000006 }
    price { 5.05 }

    trait :with_transaction do
      association :order_transaction, factory: :transaction
    end
  end
end
