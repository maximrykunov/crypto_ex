class OrdersController < ApplicationController
  include Dry::Monads[:result]

  def new
    current_price = PriceService.call("USDT", "SBTC")
    @order = Order.new(
      send_amount: 28.51,
      base_currency: Settings.base_currencies.first,
      base_address: Settings.sbtc_wallet,
      quote_currency: Settings.quote_currencies.first,
      quote_address: "tb1qey745jr5nuw64kwymxmsmeqqg36q7skpckrczm",
      price: current_price[:price]
    )
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    result = Orders::Create.new.call(order_params, current_user)

    case result
    in Success(order)
      redirect_to order_path(order), notice: "Ордер создан."
    in Failure(order)
      @order = order
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params[:order][:i_agree_kyc] ||= false
    params.require(:order).permit(:send_amount, :base_currency, :base_address, :quote_currency, :quote_address, :price, :i_agree_kyc)
  end
end
