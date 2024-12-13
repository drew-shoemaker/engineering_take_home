class CustomFieldOption < ApplicationRecord
  belongs_to :custom_field

  validates :value, presence: true
  validates :custom_field, presence: true
  validate :custom_field_must_be_enum

  private

  def custom_field_must_be_enum
    if custom_field && custom_field.field_type != 'enum'
      errors.add(:custom_field, 'must be an enum type')
    end
  end
end
