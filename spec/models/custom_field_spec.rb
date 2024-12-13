require 'rails_helper'

RSpec.describe CustomField, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:custom_field_values).dependent(:destroy) }
    it { should have_many(:custom_field_options).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:field_type) }
    it { should validate_inclusion_of(:field_type).in_array(%w[number freeform enum]) }
  end

  describe 'custom validations' do
    context 'when field_type is enum' do
      let(:custom_field) { build(:custom_field, field_type: 'enum') }

      it 'is invalid without options' do
        expect(custom_field).to be_invalid
        expect(custom_field.errors[:field_type]).to include('enum fields must have at least one option')
      end

      it 'is valid with options' do
        custom_field.custom_field_options.build(value: 'Option 1')
        expect(custom_field).to be_valid
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:custom_field, :number_type)).to be_valid
      expect(build(:custom_field, :freeform_type)).to be_valid
    end

    it 'creates enum type with options' do
      custom_field = create(:custom_field, :enum_type)
      expect(custom_field.custom_field_options.count).to eq(3)
    end
  end
end
