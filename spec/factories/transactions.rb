FactoryBot.define do
  factory :transaction do
    order
    txid { "tx_id" }
    confirmations { 0 }
    retries { 0 }
  end
end
