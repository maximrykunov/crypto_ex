require 'rails_helper'

RSpec.describe Commision::Calculate do
  context 'call' do
    let(:send_amount) { '12.445' }
    let(:price) { '5.234567' }

    it 'calculate' do
      result = described_class.call(send_amount, price)

      expect(result[:fee]).to eq 1.95432559
      expect(result[:miner_fee]).to eq 0.000006
      expect(result[:send_amount]).to eq 12.445
      expect(result[:receive_amount]).to eq 63.18985473
      expect(result[:price]).to eq 5.234567
    end
  end
end
