require "rails_helper"

RSpec.describe Api::CustomFieldOptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/custom_fields/1/custom_field_options")
        .to route_to("api/custom_field_options#index", custom_field_id: "1")
    end

    it "routes to #show" do
      expect(get: "/api/custom_fields/1/custom_field_options/2")
        .to route_to("api/custom_field_options#show", custom_field_id: "1", id: "2")
    end

    it "routes to #create" do
      expect(post: "/api/custom_fields/1/custom_field_options")
        .to route_to("api/custom_field_options#create", custom_field_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/custom_fields/1/custom_field_options/2")
        .to route_to("api/custom_field_options#update", custom_field_id: "1", id: "2")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/custom_fields/1/custom_field_options/2")
        .to route_to("api/custom_field_options#update", custom_field_id: "1", id: "2")
    end

    it "routes to #destroy" do
      expect(delete: "/api/custom_fields/1/custom_field_options/2")
        .to route_to("api/custom_field_options#destroy", custom_field_id: "1", id: "2")
    end
  end
end
