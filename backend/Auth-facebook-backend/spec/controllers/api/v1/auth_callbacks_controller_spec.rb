require "rails_helper"

RSpec.describe Api::V1::AuthCallbacksController, type: :request do
  describe "GET /api/v1/auth/facebook/callback" do
    let(:params) { { code: code } }

    context "When missing params code" do
      let(:code) { "" }

      before do
        get "/api/v1/auth/facebook/callback", params: params
      end

      it "Should raise error missing code" do
        res_data = JSON.parse response.body
        expect(res_data["status"]).to be false
        expect(res_data["response_data"]).to eq "Missing authorize code in paramater"
      end
    end

    context "When get user info success" do
      let(:code) { "random_string_code" }
      let(:basic_user_info) { { name: "User_1", id: 1234 } }
      let(:access_token) { "random_access_token" }

      before do
        allow(OauthProvider::Facebook).to receive(:authenticate).and_return([basic_user_info, access_token])
        get "/api/v1/auth/facebook/callback", params: params
      end

      it "Should response user info" do
        res_data = JSON.parse response.body
        expect(res_data["status"]).to be true
        expect(res_data["response_data"]["name"]).to eq "User_1"
      end
    end

    context "When get invalid user info" do
      let(:code) { "random_string_code" }
      let(:basic_user_info) { "" }
      let(:access_token) { "" }

      before do
        allow(OauthProvider::Facebook).to receive(:authenticate).and_return(basic_user_info, access_token)
        allow(OauthProvider::Facebook).to receive(:deauthorize)
        get "/api/v1/auth/facebook/callback", params: params
      end

      it "Should response with error invalid user info" do
        res_data = JSON.parse response.body
        expect(res_data["status"]).to be false
        expect(res_data["response_data"]).to eq "Invalid user info"
      end

    end
  end
end
