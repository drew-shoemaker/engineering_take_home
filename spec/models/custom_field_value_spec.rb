require 'rails_helper'

RSpec.describe CustomFieldValue, type: :model do
  describe 'associations' do
    it { should belong_to(:building) }
    it { should belong_to(:custom_field) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:building) }
    it { should validate_presence_of(:custom_field) }
  end

  describe 'value validation' do
    let(:building) { create(:building) }

    context 'with number type field' do
      let(:number_field) { create(:custom_field, :number_type, client: building.client) }

      it 'accepts valid numbers' do
        expect(build(:custom_field_value, building: building, custom_field: number_field, value: '42')).to be_valid
        expect(build(:custom_field_value, building: building, custom_field: number_field, value: '42.5')).to be_valid
      end

      it 'rejects non-numbers' do
        value = build(:custom_field_value, building: building, custom_field: number_field, value: 'not a number')
        expect(value).to be_invalid
        expect(value.errors[:value]).to include('must be a number')
      end
    end

    context 'with enum type field' do
      let(:enum_field) { create(:custom_field, :enum_type, client: building.client) }
      let(:valid_option) { enum_field.custom_field_options.first.value }

      it 'accepts valid enum values' do
        expect(build(:custom_field_value, building: building, custom_field: enum_field, value: valid_option)).to be_valid
      end

      it 'rejects invalid enum values' do
        value = build(:custom_field_value, building: building, custom_field: enum_field, value: 'invalid option')
        expect(value).to be_invalid
        expect(value.errors[:value]).to include('must be one of the available options')
      end
    end
  end
end
