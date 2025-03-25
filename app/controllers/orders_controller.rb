class OrdersController < ApplicationController
  def new
    @order = Order.new(
      amount: 12,
      base_currency: Settings.base_currencies.first,
      base_address: Settings.usdt_wallet,
      quote_currency: Settings.quote_currencies.first
    )
  end

  def create
  end
end
