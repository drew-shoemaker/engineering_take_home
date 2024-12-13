require 'rails_helper'

RSpec.describe CustomFieldOption, type: :model do
  describe 'associations' do
    it { should belong_to(:custom_field) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:custom_field) }
  end

  describe 'custom validations' do
    it 'validates custom field must be enum type' do
      non_enum_field = create(:custom_field, :number_type)
      option = build(:custom_field_option, custom_field: non_enum_field)
      
      expect(option).to be_invalid
      expect(option.errors[:custom_field]).to include('must be an enum type')
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:custom_field_option)).to be_valid
    end

    it 'creates building types with the building_types trait' do
      option = create(:custom_field_option, :building_types)

      expect(['Commercial', 'Residential', 'Mixed Use']).to include(option.value)
    end
  end
end
