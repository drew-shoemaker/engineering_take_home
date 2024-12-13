require 'rails_helper'

RSpec.describe Client, type: :model do
  describe 'associations' do
    it { should have_many(:buildings).dependent(:destroy) }
    it { should have_many(:custom_fields).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:client)).to be_valid
    end

    it 'creates custom fields with the with_custom_fields trait' do
      client = create(:client, :with_custom_fields)
      expect(client.custom_fields.count).to eq(3)
      expect(client.custom_fields.pluck(:field_type)).to match_array(['number', 'freeform', 'enum'])
    end
  end
end
