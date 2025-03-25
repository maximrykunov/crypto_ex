require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'Validation' do
    let(:order) { build(:order) }

    context 'Should validate' do
      it 'with all needed fields' do
        expect(order).to be_valid
      end
    end

    context 'Should not be valid' do
      it 'when price not present' do
        order.price = nil
        expect(order).not_to be_valid
      end

      it 'when amount not present' do
        order.amount = nil
        expect(order).not_to be_valid
      end

      it 'when base_currency not present' do
        order.base_currency = nil
        expect(order).not_to be_valid
      end

      it 'when quote_currency not present' do
        order.quote_currency = nil
        expect(order).not_to be_valid
      end
    end
  end
end
