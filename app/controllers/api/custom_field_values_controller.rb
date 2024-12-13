module Api
  class CustomFieldValuesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_custom_field_value, only: [:show, :update, :destroy]
    before_action :set_building, only: [:index, :create]

    def index
      @custom_field_values = @building.custom_field_values.includes(:custom_field)
      render json: {
        status: 'success',
        custom_field_values: @custom_field_values.map { |cfv|
          {
            id: cfv.id,
            field_name: cfv.custom_field.name,
            field_type: cfv.custom_field.field_type,
            value: cfv.value
          }
        }
      }
    end

    def show
      render json: {
        status: 'success',
        custom_field_value: {
          id: @custom_field_value.id,
          field_name: @custom_field_value.custom_field.name,
          field_type: @custom_field_value.custom_field.field_type,
          value: @custom_field_value.value
        }
      }
    end

    def create
      @custom_field_value = @building.custom_field_values.build(custom_field_value_params)

      if @custom_field_value.save
        render json: { 
          status: 'success', 
          message: 'Value created successfully', 
          custom_field_value: @custom_field_value 
        }, status: :created
      else
        render json: { 
          status: 'error', 
          errors: @custom_field_value.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end

    def update
      if @custom_field_value.update(custom_field_value_params)
        render json: { 
          status: 'success', 
          message: 'Value updated successfully', 
          custom_field_value: @custom_field_value 
        }
      else
        render json: { 
          status: 'error', 
          errors: @custom_field_value.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end

    def destroy
      if @custom_field_value.destroy
        render json: {
          status: 'success',
          message: 'Value deleted successfully'
        }
      else
        render json: {
          status: 'error',
          errors: @custom_field_value.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def set_custom_field_value
      @custom_field_value = CustomFieldValue.find(params[:id])
    end

    def set_building
      @building = Building.find(params[:building_id])
    end

    def custom_field_value_params
      params.require(:custom_field_value).permit(:value, :custom_field_id)
    end
  end
end
