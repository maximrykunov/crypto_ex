require 'rails_helper'

RSpec.describe CreateOrderTransactionWorker, type: :worker do
  let(:order) { create(:order, status: :pending) }

  before do
    allow(Settings).to receive(:sbtc_wallet).and_return('wallet_address')
  end

  describe '#perform' do
    context 'when order does not exist' do
      it 'returns :skip' do
        expect(subject.perform(-1)).to eq(:skip)
      end
    end

    context 'when order is not pending' do
      it 'returns :skip' do
        order.update(status: :completed)
        expect(subject.perform(order.id)).to eq(:skip)
      end
    end

    context 'when order already has a transaction' do
      let!(:order) { create(:order, :with_transaction, status: :pending) }

      it 'returns :skip' do
        expect(subject.perform(order.id)).to eq(:skip)
      end
    end

    context 'when Transactions::Create fails' do
      it 'updates order status to cancelled' do
        allow(Transactions::Create).to receive(:call).and_return(Dry::Monads::Result::Failure.new([ :api_error, 'anything' ]))

        subject.perform(order.id)

        expect(order.reload.status).to eq('cancelled')
        expect(order.reload.message).to eq("[:api_error, \"anything\"]")
      end
    end

    context 'when Transactions::Create succeeds' do
      it 'creates a transaction' do
        allow(Transactions::Create).to receive(:call).and_return(Dry::Monads::Result::Success.new('txid123'))
        allow(Transaction).to receive(:create!).and_return(double(:transaction))

        expect(Transaction).to receive(:create!).with(order_id: order.id, txid: 'txid123')
        subject.perform(order.id)
      end
    end
  end
end
