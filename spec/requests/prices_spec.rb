require 'rails_helper'

RSpec.describe "Prices", type: :request do
  describe "GET /fetch_price" do
    it "returns http success", vcr: true do
      get "/prices/fetch_price"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["price"]).to eq(5.296610904878165)
    end
  end

end
