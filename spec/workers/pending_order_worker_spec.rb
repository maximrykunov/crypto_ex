require 'rails_helper'

RSpec.describe PendingOrderWorker, type: :worker do
  let!(:order_1) { create(:order, :with_transaction, status: 'pending') }
  let!(:order_2) { create(:order, :with_transaction, status: 'pending') }
  let!(:order_3) { create(:order, :with_transaction, status: 'completed') }

  before do
    allow(CheckTransactionWorker).to receive(:perform_async)
  end

  it 'обрабатывает все заказы с состоянием pending и вызывает CheckTransactionWorker для каждой транзакции' do
    PendingOrderWorker.new.perform

    expect(CheckTransactionWorker).to have_received(:perform_async).with(order_1.order_transaction.id)
    expect(CheckTransactionWorker).to have_received(:perform_async).with(order_2.order_transaction.id)

    expect(CheckTransactionWorker).not_to have_received(:perform_async).with(order_3.order_transaction.id)
  end
end
