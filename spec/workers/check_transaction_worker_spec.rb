require 'rails_helper'

RSpec.describe CheckTransactionWorker, type: :worker do
  let!(:transaction) { create(:transaction) }

  before do
    allow(Transactions::Check).to receive(:call)
  end

  it 'Calls Transactions::Check with correct transaction_id' do
    CheckTransactionWorker.new.perform(transaction.id)

    expect(Transactions::Check).to have_received(:call).with(transaction.id)
  end
end
