require "rails_helper"

RSpec.describe Api::CustomFieldValuesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/buildings/1/custom_field_values")
        .to route_to("api/custom_field_values#index", building_id: "1")
    end

    it "routes to #show" do
      expect(get: "/api/buildings/1/custom_field_values/2")
        .to route_to("api/custom_field_values#show", building_id: "1", id: "2")
    end

    it "routes to #create" do
      expect(post: "/api/buildings/1/custom_field_values")
        .to route_to("api/custom_field_values#create", building_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/buildings/1/custom_field_values/2")
        .to route_to("api/custom_field_values#update", building_id: "1", id: "2")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/buildings/1/custom_field_values/2")
        .to route_to("api/custom_field_values#update", building_id: "1", id: "2")
    end

    it "routes to #destroy" do
      expect(delete: "/api/buildings/1/custom_field_values/2")
        .to route_to("api/custom_field_values#destroy", building_id: "1", id: "2")
    end
  end
end
