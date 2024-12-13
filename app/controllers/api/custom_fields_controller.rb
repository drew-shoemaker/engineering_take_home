module Api
  class CustomFieldsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_custom_field, only: [:show]

    def index
      @custom_fields = CustomField.all
      render json: { status: 'success', custom_fields: @custom_fields }
    end

    def show
      render json: {
        status: 'success',
        custom_field: @custom_field.as_json(include: :custom_field_options)
      }
    end

    private

    def set_custom_field
      @custom_field = CustomField.find(params[:id])
    end
  end
end
