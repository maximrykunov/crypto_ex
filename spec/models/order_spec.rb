# == Schema Information
#
# Table name: orders
#
#  id             :bigint           not null, primary key
#  base_address   :string           not null
#  base_currency  :string           not null
#  fee            :decimal(20, 8)   not null
#  miner_fee      :decimal(20, 8)   not null
#  order_side     :integer          default("exchange"), not null
#  order_type     :integer          default("limit"), not null
#  price          :decimal(20, 8)   not null
#  quote_address  :string           not null
#  quote_currency :string           not null
#  receive_amount :decimal(20, 8)   not null
#  send_amount    :decimal(20, 8)   not null
#  status         :integer          default("pending"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
        order.send_amount = nil
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
