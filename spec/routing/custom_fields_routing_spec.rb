require "rails_helper"

RSpec.describe Api::CustomFieldsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/custom_fields").to route_to("api/custom_fields#index")
    end

    it "routes to #show" do
      expect(get: "/api/custom_fields/1").to route_to("api/custom_fields#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/api/custom_fields").to route_to("api/custom_fields#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api/custom_fields/1").to route_to("api/custom_fields#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api/custom_fields/1").to route_to("api/custom_fields#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api/custom_fields/1").to route_to("api/custom_fields#destroy", id: "1")
    end
  end
end
