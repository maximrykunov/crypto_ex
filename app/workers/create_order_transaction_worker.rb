class CreateOrderTransactionWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by(id: order_id)

    return :skip unless order
    return :skip unless order.pending?
    return :skip if order.order_transaction

    result = CreateTransactionService.call(Settings.sbtc_wallet, order.quote_address, order.send_amount)

    if result.failure?
      order.update(message: result.failure.to_s, status: :cancelled)
    else
      Transaction.create!(order_id: order.id, txid: result.value!)
    end
  end
end
