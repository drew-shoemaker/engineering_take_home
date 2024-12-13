module Api
  class ClientsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_client, only: [:show, :custom_fields]

    def index
      @clients = Client.all
      render json: { status: 'success', clients: @clients }
    end

    def show
      render json: {
        status: 'success',
        client: @client,
        custom_fields: @client.custom_fields
      }
    end

    def custom_fields
      unless @client
        render json: {
          status: 'error',
          message: 'Client not found'
        }, status: :not_found
        return
      end

      custom_fields = @client.custom_fields.map do |field|
        field_data = {
          id: field.id,
          name: field.name,
          field_type: field.field_type
        }
        
        # Include options for enum fields
        if field.field_type == 'enum'
          field_data[:options] = field.custom_field_options.pluck(:value)
        end
        
        field_data
      end

      render json: {
        status: 'success',
        custom_fields: custom_fields
      }
    end

    private

    def set_client
      @client = Client.find_by(id: params[:id])
      
      unless @client
        render json: {
          status: 'error',
          message: 'Client not found'
        }, status: :not_found
        return
      end
    end
  end
end
