require 'rails_helper'

RSpec.describe "Prices", type: :request do
  describe "GET /fetch_price" do
    it "returns external data", vcr: true do
      allow(Settings).to receive(:block_price).and_return(false)

      get "/prices/fetch_price"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["price"]).to eq(5.29568502)
    end

    it "returns stub data" do
      allow(Settings).to receive(:block_price).and_return(true)

      get "/prices/fetch_price"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["price"]).to eq(5.123)
    end
  end
end
