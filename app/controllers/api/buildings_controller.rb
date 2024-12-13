module Api
  class BuildingsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_building, only: [:show, :update, :destroy]

    def index
      @buildings = Building.includes(:client, :custom_field_values)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .per(params[:per_page] || 10)

      render json: {
        status: 'success',
        buildings: @buildings.as_json(include: { 
          client: { 
            only: [:id, :name],
            include: { custom_fields: { only: [:id, :name, :field_type] } }
          },
          custom_field_values: {
            include: { custom_field: { only: [:id, :name, :field_type] } }
          }
        })
      }
    end

    def show
      render json: {
        status: 'success',
        building: @building.as_json(include: { 
          client: { only: [:id, :name] },
          custom_field_values: {
            include: { custom_field: { only: [:id, :name, :field_type] } }
          }
        })
      }
    end

    def create
      @building = Building.new(building_params)
      
      if @building.save && update_custom_fields
        render json: { 
          status: 'success', 
          message: 'Building was successfully created.',
          building: @building 
        }, status: :created
      else
        render json: { 
          status: 'error', 
          errors: @building.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end

    def update
      if @building.update(building_params) && update_custom_fields
        render json: { 
          status: 'success', 
          message: 'Building was successfully updated.',
          building: @building 
        }
      else
        render json: { 
          status: 'error', 
          errors: @building.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end

    def destroy
      if @building.destroy
        render json: { status: 'success', message: 'Building successfully deleted' }, status: :ok
      else
        render json: { status: 'error', errors: @building.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_building
      @building = Building.find(params[:id])
    end

    def building_params
      params.require(:building).permit(
        :address, :state, :zip, :client_id, :city
      )
    end

    def update_custom_fields
      return true unless params.dig(:building, :custom_fields)
      
      params[:building][:custom_fields].each do |field_id, value|
        custom_field = CustomField.find(field_id)
        field_value = @building.custom_field_values
                              .find_or_initialize_by(custom_field: custom_field)
        field_value.value = value
        return false unless field_value.save
      end
      true
    end
  end
end
