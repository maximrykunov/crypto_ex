require 'rails_helper'

RSpec.describe CheckTransactionWorker, type: :worker do
  let!(:transaction) { create(:transaction) }

  before do
    allow(CheckTransactionService).to receive(:call)
  end

  it 'вызывает CheckTransactionService с правильным transaction_id' do
    CheckTransactionWorker.new.perform(transaction.id)

    expect(CheckTransactionService).to have_received(:call).with(transaction.id)
  end
end