class CustomField < ApplicationRecord
  belongs_to :client
  has_many :custom_field_values, dependent: :destroy
  has_many :custom_field_options, dependent: :destroy

  validates :name, presence: true
  validates :field_type, presence: true, 
            inclusion: { in: %w[number freeform enum] }
  validates :client, presence: true
  
  validate :ensure_options_for_enum

  private

  def ensure_options_for_enum
    if field_type == 'enum' && custom_field_options.empty?
      errors.add(:field_type, 'enum fields must have at least one option')
    end
  end
end
