require 'rails_helper'

describe CreateTransactionService do
  subject { CreateTransactionService.call(sender_address, recipient_address, amount) }

  context 'call' do
    let(:sender_address) { 'tb1q6jv5ze5h0rey4wf6jsukuw5mznrxwc2sxnexgd' }
    let(:recipient_address) { 'tb1qey745jr5nuw64kwymxmsmeqqg36q7skpckrczm' }
    let(:amount) { 0.00002 }

    context 'when everything succeeds' do
      it 'returns Success with transaction hash', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Success)
        expect(result.value!).to eq('e61c0c19ad3c03409cdd7988a8c12c4986673b47d28cbc9ceeba0fb99a4c3da8')
      end
    end

    context 'when UTXO fetch fails' do
      it 'returns Failure with api_error', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to match_array([ :api_error, anything ])
      end
    end

    context 'when no UTXOs found' do
      it 'returns Failure with no_utxos', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to match_array([ :no_utxos, anything ])
      end
    end

    context 'when small_balance' do
      let(:amount) { 0.02 }

      it 'returns Failure with small_balance', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to match_array([ :small_balance, anything ])
      end
    end

    context 'when small_balance_with_fee' do
      let(:amount) { 0.01346974 }

      it 'returns Failure with small_balance_with_fee', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to match_array([ :small_balance_with_fee, anything ])
      end
    end

    context 'when send bad transaction' do
      it 'returns Failure with api_tx_error', vcr: true do
        result = subject
        expect(result).to be_a(Dry::Monads::Failure)
        expect(result.failure).to match_array([ :api_tx_error, anything ])
      end
    end
  end
end
