require 'rails_helper'

describe CheckTransactionService do
  subject { CheckTransactionService.call(transaction_id) }

  context 'call' do
    context 'undefined transaction' do
      let(:transaction_id) { 0 }

      it 'returns order' do
        expect(subject).to eq :skip
      end
    end

    context 'transaction for completed order' do
      let(:order) { create(:order, status: :completed) }
      let(:transaction) { create(:transaction, order: order) }
      let(:transaction_id) { transaction.id }

      it 'returns order' do
        expect(subject).to eq :skip
      end
    end

    context 'transaction for pending order' do
      let(:order) { create(:order, status: :pending) }
      let(:transaction) { create(:transaction, order: order) }
      let(:transaction_id) { transaction.id }

      it 'do not change status if confirmations too small', vcr: true do
        expect(subject).to eq :pending

        expect(transaction.reload.confirmations).to eq 3
        expect(order.reload.status).to eq 'pending'
      end

      it 'change status if confirmations enough', vcr: true do
        expect(subject).to eq :completed

        expect(transaction.reload.confirmations).to eq 158
        expect(order.reload.status).to eq 'completed'
      end
    end
  end
end
