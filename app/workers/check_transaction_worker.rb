class CheckTransactionWorker
  include Sidekiq::Worker

  def perform(transaction_id)
    CheckTransactionService.call(transaction_id)
  end
end
