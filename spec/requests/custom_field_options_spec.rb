require 'rails_helper'

RSpec.describe "/api/custom_fields/:custom_field_id/custom_field_options", type: :request do
  let(:client) { create(:client) }
  let!(:custom_field) { create(:custom_field, :enum_type, client: client) }
  
  let(:valid_attributes) do
    {
      value: "New Option"
    }
  end

  let(:invalid_attributes) do
    {
      value: ""
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      create(:custom_field_option, custom_field: custom_field)
      get api_custom_field_custom_field_options_url(custom_field)

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["custom_field_options"]).to be_present
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CustomFieldOption" do
        expect {
          post api_custom_field_custom_field_options_url(custom_field), 
               params: { custom_field_option: valid_attributes }
        }.to change(CustomFieldOption, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new CustomFieldOption" do
        expect {
          post api_custom_field_custom_field_options_url(custom_field), 
               params: { custom_field_option: invalid_attributes }
        }.to change(CustomFieldOption, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "validates custom field type" do
        number_field = create(:custom_field, :number_type, client: client)
        post api_custom_field_custom_field_options_url(number_field), 
             params: { custom_field_option: valid_attributes }
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
