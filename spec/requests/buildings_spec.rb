require 'rails_helper'


RSpec.describe "/api/buildings", type: :request do

  let(:client) { create(:client, :with_custom_fields) }
  
  let(:valid_attributes) do
    {
      address: "123 Main St",
      state: "NY",
      zip: "10001",
      client_id: client.id,
      custom_fields: {
        client.custom_fields.first.id.to_s => "42"
      }
    }
  end

  let(:invalid_attributes) do
    {
      address: "",
      state: "",
      zip: "",
      client_id: nil
    }
  end

  describe "GET /index" do
    it "renders a successful response with buildings and custom fields" do
      create(:building, :with_custom_field_values, client: client)
      get api_buildings_url, headers: { Accept: "application/json" }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["buildings"]).to be_present
      expect(json["buildings"].first["client"]["name"]).to eq(client.name)
    end

    it "includes pagination" do
      create_list(:building, 15, client: client)
      get api_buildings_url, 
          params: { page: 2, per_page: 10 },
          headers: { Accept: "application/json" }
      
      json = JSON.parse(response.body)
      expect(json["buildings"].length).to eq(5)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Building with custom fields" do
        expect {
          post api_buildings_url,
               params: { building: valid_attributes }.to_json,
               headers: { Accept: "application/json", "Content-Type": "application/json" }
        }.to change(Building, :count).by(1)
         .and change(CustomFieldValue, :count).by(1)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid parameters" do
      it "does not create a new Building" do
        expect {
          post api_buildings_url, params: { building: invalid_attributes }.to_json,
               headers: { Accept: "application/json", "Content-Type": "application/json" }
        }.to change(Building, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
      end

      it "validates custom field types" do
        invalid_custom_field = {
          building: valid_attributes.merge(
            custom_fields: { 
              client.custom_fields.first.id.to_s => "not a number" 
            }
          )
        }
        
        post api_buildings_url, params: invalid_custom_field.to_json,
             headers: { Accept: "application/json", "Content-Type": "application/json" }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:building) { create(:building, client: client) }
    
    context "with valid parameters" do
      let(:new_attributes) do
        {
          address: "456 New St",
          custom_fields: {
            client.custom_fields.first.id.to_s => "99"
          }
        }
      end

      it "updates the requested building and its custom fields" do
        patch api_building_url(building), params: { building: new_attributes }.to_json,
             headers: { Accept: "application/json", "Content-Type": "application/json" }
        
        building.reload
        expect(building.address).to eq("456 New St")
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        patch api_building_url(building), params: { building: invalid_attributes }.to_json,
             headers: { Accept: "application/json", "Content-Type": "application/json" }
        
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
      end
    end
  end
end
