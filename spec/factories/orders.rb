# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  base_address   :string           not null
#  base_currency  :string           not null
#  fee            :decimal(20, 8)   not null
#  message        :string
#  miner_fee      :decimal(20, 8)   not null
#  order_side     :integer          default("exchange"), not null
#  order_type     :integer          default("limit"), not null
#  price          :decimal(20, 8)   not null
#  quote_address  :string           not null
#  quote_currency :string           not null
#  receive_amount :decimal(20, 8)   not null
#  send_amount    :decimal(20, 8)   not null
#  status         :integer          default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
