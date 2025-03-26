class OrdersController < ApplicationController
  # allow_unauthenticated_access
  def new
    current_price = PriceService.call("USDT", "SBTC")
    @order = Order.new(
      send_amount: 28.51,
      base_currency: Settings.base_currencies.first,
      base_address: Settings.usdt_wallet,
      quote_currency: Settings.quote_currencies.first,
      quote_address: "bc1qar0srrr8c4xywcrvdp7rkxw7y4f55q9k0pmd4d",
      price: current_price[:price]
    )
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    prepared_params = prepare_params(order_params)
    @order = Order.new(prepared_params)

    if @order.save
      respond_to do |format|
        format.html { redirect_to order_path(@order), notice: "Пользователь создан." }
        format.js   # ищет create.js.erb
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.js   # ищет create.js.erb для обработки ошибок
      end
    end
  end

  private

  def order_params
    params[:order][:i_agree_kyc] ||= false
    params.require(:order).permit(:send_amount, :base_currency, :base_address, :quote_currency, :quote_address, :price, :i_agree_kyc)
  end

  def prepare_params(params)
    commision = CommisionService.call(params[:send_amount], params[:price])
    params.merge(
      {
        user: current_user,
        base_address: Settings.usdt_wallet,
        send_amount: commision[:send_amount],
        receive_amount: commision[:receive_amount],
        fee: commision[:fee],
        miner_fee: commision[:miner_fee],
        price: commision[:price]
      })
  end
end
