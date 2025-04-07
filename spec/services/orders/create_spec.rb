require 'rails_helper'

RSpec.describe Orders::Create do
  subject(:service) { described_class.new }

  include Dry::Monads[:result]

  let(:user) { build_stubbed(:user) }
  let(:order) { build_stubbed(:order, user: user) }
  let(:send_amount) { 12 }
  let(:base_currency) { 'USDT' }
  let(:quote_currency) { 'SBTC' }
  let(:quote_address) { 'tb1qey745jr5nuw64kwymxmsmeqqg36q7skpckrczm' }
  let(:price) { 5.23 }
  let(:params) do
    {
      send_amount:,
      base_currency:,
      quote_currency:,
      quote_address:,
      price:,
      i_agree_kyc: true
    }
  end

  let(:commision_result) do
    {
      send_amount: 11.5,
      receive_amount: 0.5,
      fee: 0.5,
      miner_fee: 0.1,
      price: 5.23
    }
  end

  before do
    allow(Commision::Calculate).to receive(:call).and_return(commision_result)
    allow(CreateOrderTransactionWorker).to receive(:perform_async)
    allow(Order).to receive(:new).and_return(order)
  end

  describe '#call' do
    context 'when order is valid' do
      before do
        allow(order).to receive(:save).and_return(true)
      end

      it 'creates order with correct attributes' do
        result = service.call(params, user)

        expect(result).to be_success
        expect(result.value!).to eq(order)

        expected_attributes = {
          user_id: user.id,
          base_currency:,
          base_address: Settings.usdt_wallet,
          quote_currency:,
          quote_address:,
          i_agree_kyc: true,
          send_amount: commision_result[:send_amount],
          receive_amount: commision_result[:receive_amount],
          fee: commision_result[:fee],
          miner_fee: commision_result[:miner_fee],
          price: commision_result[:price],
          order_type: :limit,
          order_side: :exchange,
          status: :pending
        }

        expect(Order).to have_received(:new).with(expected_attributes)
      end

      it 'schedules transaction creation' do
        result = service.call(params, user)

        expect(CreateOrderTransactionWorker).to have_received(:perform_async).with(order.id)
      end
    end

    context 'when order is invalid' do
      before do
        allow(order).to receive(:save).and_return(false)
        allow(order).to receive(:errors).and_return(
          double('errors', present?: true, full_messages: [ 'Some error message' ])
        )
      end

      it 'returns failure with order containing errors' do
        result = service.call(params, user)

        expect(result).to be_failure
        expect(result.failure).to eq(order)
      end

      it 'does not schedule transaction creation' do
        service.call(params, user)

        expect(CreateOrderTransactionWorker).not_to have_received(:perform_async)
      end
    end
  end
end
