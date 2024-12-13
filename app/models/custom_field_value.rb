class CustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  validates :value, presence: true
  validates :building, presence: true
  validates :custom_field, presence: true
  validates :value, 
            numericality: { message: 'must be a number' },
            if: :number_type?
  validate :validate_enum_value, if: :enum_type?

  private

  def number_type?
    custom_field&.field_type == 'number'
  end

  def enum_type?
    custom_field&.field_type == 'enum'
  end

  def validate_enum_value
    return if custom_field&.custom_field_options&.exists?(value: value)
    errors.add(:value, 'must be one of the available options')
  end
end
