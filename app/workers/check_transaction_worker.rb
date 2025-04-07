class CheckTransactionWorker
  include Sidekiq::Worker

  def perform(transaction_id)
    Transactions::Check.call(transaction_id)
  end
end
