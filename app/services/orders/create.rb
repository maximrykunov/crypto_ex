require "dry/monads"

module Orders
  class Create
    include Dry::Monads[:result, :do]

    def call(params, user)
      order_params = yield prepare_order_params(params)
      order = Order.new(params.merge(user_id: user.id, **order_params))

      if order.save
        yield schedule_transaction_creation(order)
        Success(order)
      else
        Failure(order)
      end
    end

    private

    def prepare_order_params(params)
      commision = Commision::Calculate.call(params[:send_amount], params[:price])

      Success(
        {
          base_address: Settings.usdt_wallet,
          send_amount: commision[:send_amount],
          receive_amount: commision[:receive_amount],
          fee: commision[:fee],
          miner_fee: commision[:miner_fee],
          price: commision[:price],
          order_type: :limit,
          order_side: :exchange,
          status: :pending
        }
      )
    end

    def schedule_transaction_creation(order)
      CreateOrderTransactionWorker.perform_async(order.id)
      Success(order)
    end
  end
end
