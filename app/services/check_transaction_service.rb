require "net/http"

class CheckTransactionService < ApplicationService
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def call
    transaction = Transaction.find_by(id: id)

    return :skip unless transaction
    return :skip unless transaction.order.pending?

    if transaction.retries >= Settings.max_retries
      transaction.order.update(status: :cancelled)

      return :cancelled
    end

    confirmation_result = get_confirmations(transaction.txid)
    if confirmation_result[:confirmed]
      transaction.update(confirmations: confirmation_result[:confirmations])
      transaction.order.update(status: :completed)

      :completed
    else
      transaction.update(confirmations:, retries: transaction.retries + 1)

      :pending
    end
  end

  private

  def get_confirmations(txid)
    confirmed = false

    begin
      tx_url = URI("#{Settings.explorer_url}/api/tx/#{txid}")

      # Получаем данные о транзакции
      tx_response = Net::HTTP.get(tx_url)
      tx_data = JSON.parse(tx_response)

      # метод с вычисленим блока не 
      block_height = tx_data.dig("status", "block_height")

      # Получаем текущую высоту блока
      block_url = URI("#{Settings.explorer_url}/api/blocks/tip/height")
      block_response = Net::HTTP.get(block_url)
      current_height = block_response.to_i

      confirmations = block_height ? (current_height - block_height + 1) : 0
      confirmed = tx_data['status']['confirmed']
    rescue => e
      Rails.logger.error("CheckTransactionService #{id}: #{e.message}")
      confirmations = 0
    end

    {confirmed:, confirmations:}
  end
end
