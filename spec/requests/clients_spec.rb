require 'rails_helper'

RSpec.describe "/api/clients", type: :request do
  let(:valid_attributes) do
    {
      name: "New Client"
    }
  end

  let(:invalid_attributes) do
    {
      name: ""
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      create(:client)
      get api_clients_url
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["clients"]).to be_present
    end
  end

  describe "GET /show" do
    it "renders a successful response with custom fields" do
      client = create(:client, :with_custom_fields)
      get api_client_url(client)
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["client"]).to be_present
      expect(json["custom_fields"]).to be_present
    end
  end
end
