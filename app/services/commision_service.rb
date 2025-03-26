class CommisionService < ApplicationService
  attr_reader :send_amount, :price

  def initialize(send_amount, price)
    @send_amount = send_amount.to_f.round(8)
    @price =  price.to_f.round(8)
  end

  def call
    miner_fee = Settings.miner_fee.round(8)
    fee = (send_amount * price * Settings.commision_rate).round(8)
    receive_amount = (send_amount * price - fee - miner_fee).round(8)

    result = {
      fee: fee,
      miner_fee: miner_fee,
      send_amount: send_amount,
      receive_amount: receive_amount,
      price: price
    }

    result
  end
end
