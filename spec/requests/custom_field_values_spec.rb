require 'rails_helper'

RSpec.describe "/api/buildings/:building_id/custom_field_values", type: :request do
  let(:client) { create(:client, :with_custom_fields) }
  let(:building) { create(:building, client: client) }
  let(:custom_field) { client.custom_fields.first }
  
  let(:valid_attributes) do
    {
      value: "42",
      custom_field_id: custom_field.id,
      building_id: building.id
    }
  end

  let(:invalid_attributes) do
    {
      value: "",
      custom_field_id: nil,
      building_id: nil
    }
  end

  describe "GET /index" do
    it "renders a successful response with field metadata" do
      create(:custom_field_value, building: building, custom_field: custom_field)
      get api_building_custom_field_values_url(building)
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["custom_field_values"]).to be_present
      expect(json["custom_field_values"].first["field_name"]).to be_present
      expect(json["custom_field_values"].first["field_type"]).to be_present
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      custom_field_value = create(:custom_field_value, building: building, custom_field: custom_field)
      get api_building_custom_field_value_url(building, custom_field_value)
      
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["custom_field_value"]).to be_present
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CustomFieldValue" do
        expect {
          post api_building_custom_field_values_url(building), 
               params: { custom_field_value: valid_attributes }
        }.to change(CustomFieldValue, :count).by(1)

        json = JSON.parse(response.body)
        expect(json["status"]).to eq("success")
        expect(json["custom_field_value"]).to be_present
      end

      it "validates field type constraints" do
        number_field = create(:custom_field, :number_type, client: client)
        post api_building_custom_field_values_url(building), 
             params: { 
               custom_field_value: valid_attributes.merge(
                 custom_field_id: number_field.id,
                 value: "not a number"
               ) 
             }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)

        expect(json["errors"]).to include("Value must be a number")
      end
    end

    context "with invalid parameters" do
      it "does not create a new CustomFieldValue" do
        expect {
          post api_building_custom_field_values_url(building), 
               params: { custom_field_value: invalid_attributes }
        }.to change(CustomFieldValue, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
      end
    end
  end

  describe "PATCH /update" do
    let(:custom_field_value) { create(:custom_field_value, building: building, custom_field: custom_field) }
    
    context "with valid parameters" do
      let(:new_attributes) do
        {
          value: "99"
        }
      end

      it "updates the requested custom_field_value" do
        patch api_building_custom_field_value_url(building, custom_field_value), 
              params: { custom_field_value: new_attributes }
        
        custom_field_value.reload
        expect(custom_field_value.value).to eq("99")
        expect(response).to be_successful
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("success")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        patch api_building_custom_field_value_url(building, custom_field_value), 
              params: { custom_field_value: invalid_attributes }
        
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json["status"]).to eq("error")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested custom_field_value" do
      custom_field_value = create(:custom_field_value, building: building, custom_field: custom_field)
      expect {
        delete api_building_custom_field_value_url(building, custom_field_value)
      }.to change(CustomFieldValue, :count).by(-1)

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
    end
  end
end
