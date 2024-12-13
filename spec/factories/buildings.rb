FactoryBot.define do
  factory :building do
    sequence(:address) { |n| "#{n} Main Street" }
    state { ['NY', 'CA', 'TX', 'FL', 'IL'].sample }
    city { ['New York', 'Los Angeles', 'Houston', 'Miami', 'Chicago'].sample }
    sequence(:zip) { |n| sprintf('%05d', n) }
    association :client

    trait :with_custom_field_values do
      association :client, :with_custom_fields

      after(:create) do |building|
        building.client.custom_fields.each do |custom_field|
          create(:custom_field_value, 
                building: building, 
                custom_field: custom_field)
        end
      end
    end
  end
end
