require 'rails_helper'

RSpec.describe "Orders", type: :request do
  let(:user) { create(:user) }

  before do
    post "/session", params: { email_address: user.email_address, password: user.password } # Эмуляция входа
  end

  describe "GET /new" do
    it "returns http success" do
      get "/orders/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    let(:send_amount) { 12 }
    let(:base_currency) { 'USDT' }
    let(:quote_currency) { 'SBTC' }
    let(:quote_address) { 'tb1qey745jr5nuw64kwymxmsmeqqg36q7skpckrczm' }
    let(:price) { 5.23 }
    let(:params) do
      {
        order: {
          send_amount:,
          base_currency:,
          quote_currency:,
          quote_address:,
          price:,
          i_agree_kyc: true
        }
      }
    end

    before do
      allow(CreateOrderTransactionWorker).to receive(:perform_async)
    end

    it "returns http success" do
      post "/orders", params: params
      expect(response).to have_http_status(302)
    end

    it "call CreateOrderTransactionWorker" do
      post "/orders", params: params
      expect(CreateOrderTransactionWorker).to have_received(:perform_async)
    end
  end

  describe "GET /show" do
    context 'self order' do
      let(:order) { create(:order, user: user) }

      it "returns http success" do
        get "/orders/#{order.id}"
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid order' do
      it "returns http success" do
        get "/orders/0"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
