class PendingOrderWorker
  include Sidekiq::Worker

  def perform
    Order.pending.joins(:order_transaction).each do |order|
      CheckTransactionWorker.perform_async(order.order_transaction.id)
    end
  end
end
