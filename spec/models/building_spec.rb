require 'rails_helper'

RSpec.describe Building, type: :model do
  describe 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:custom_field_values).dependent(:destroy) }
    it { should have_many(:custom_fields).through(:client) }
  end

  describe 'validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:client) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:building)).to be_valid
    end

    it 'creates custom field values with the with_custom_field_values trait' do
      building = create(:building, :with_custom_field_values)
      # debugger
      expect(building.custom_field_values).to be_present
      expect(building.custom_field_values.count).to eq(building.client.custom_fields.count)
    end
  end
end
