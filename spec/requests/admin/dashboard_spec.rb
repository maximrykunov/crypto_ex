require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  describe "GET /show" do
    before do
      post "/session", params: { email_address: user.email_address, password: user.password } # Эмуляция входа
    end

    context 'admin user' do
      let(:user) { create(:user, :with_admin) }

      it "returns http success" do
        get "/admin"
        expect(response).to have_http_status(:success)
      end
    end

    context 'regular user' do
      let(:user) { create(:user) }

      it "returns http success" do
        get "/admin"
        expect(response).to have_http_status(302)
      end
    end
  end
end
