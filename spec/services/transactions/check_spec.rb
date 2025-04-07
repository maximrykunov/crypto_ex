require 'rails_helper'

RSpec.describe Transactions::Check do
  subject { described_class.call(transaction_id) }

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

      context 'transaction for pending order with less than 10 retries' do
        it 'do not change status if confirmed is false', vcr: true do
          expect(subject).to eq :pending

          expect(transaction.reload.confirmations).to eq 3
          expect(order.reload.status).to eq 'pending'
        end

        it 'change status if confirmed is true', vcr: true do
          expect(subject).to eq :completed

          expect(transaction.reload.confirmations).to eq 158
          expect(order.reload.status).to eq 'completed'
        end

        it 'increase retries if get error', vcr: true do
          expect(subject).to eq :pending

          expect(transaction.reload.retries).to eq 1
          expect(order.reload.status).to eq 'pending'
        end
      end

      context 'transaction for pending order with 10 retries' do
        let(:transaction) { create(:transaction, order: order, retries: 10) }

        it 'change status if confirmations enough' do
          expect(subject).to eq :cancelled

          expect(transaction.reload.retries).to eq 10
          expect(order.reload.status).to eq 'cancelled'
        end
      end
    end
  end
end
