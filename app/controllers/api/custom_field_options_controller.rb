module Api
  class CustomFieldOptionsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_custom_field_option, only: [:show, :update, :destroy]
    before_action :set_custom_field, only: [:index, :create]

    def index
      @custom_field_options = @custom_field.custom_field_options
      render json: { status: 'success', custom_field_options: @custom_field_options }
    end

    def show
      render json: { status: 'success', custom_field_option: @custom_field_option }
    end

    def create
      @custom_field_option = @custom_field.custom_field_options.build(custom_field_option_params)

      if @custom_field.field_type == 'enum' && @custom_field_option.save
        render json: { 
          status: 'success', 
          message: 'Option created successfully', 
          custom_field_option: @custom_field_option 
        }, status: :created
      else
        render json: { 
          status: 'error', 
          errors: @custom_field_option.errors.full_messages 
        }, status: :unprocessable_entity
      end
    end

    def update
      if @custom_field_option.update(custom_field_option_params)
        render json: {
          status: 'success',
          message: 'Option updated successfully',
          custom_field_option: @custom_field_option
        }
      else
        render json: {
          status: 'error', 
          errors: @custom_field_option.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    def destroy
      if @custom_field_option.destroy
        render json: {
          status: 'success',
          message: 'Option deleted successfully'
        }
      else
        render json: {
          status: 'error',
          errors: @custom_field_option.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def set_custom_field_option
      @custom_field_option = CustomFieldOption.find(params[:id])
    end

    def set_custom_field
      @custom_field = CustomField.find(params[:custom_field_id])
    end

    def custom_field_option_params
      params.require(:custom_field_option).permit(:value)
    end
  end
end
