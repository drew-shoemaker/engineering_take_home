require 'rails_helper'

RSpec.describe "/api/custom_fields", type: :request do
  let(:client) { create(:client) }
  
  let(:valid_attributes) do
    {
      name: "Building Height",
      field_type: "number",
      client_id: client.id
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      field_type: "invalid_type",
      client_id: nil
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      create(:custom_field, :number_type, client: client)
      get api_custom_fields_url
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["custom_fields"]).to be_present
    end
  end

  describe "GET /show" do
    it "renders a successful response with options for enum fields" do
      custom_field = create(:custom_field, :enum_type, client: client)
      get api_custom_field_url(custom_field)
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["custom_field"]["custom_field_options"]).to be_present
    end
  end
end
