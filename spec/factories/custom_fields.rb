FactoryBot.define do
  factory :custom_field do
    sequence(:name) { |n| "Custom Field #{n}" }
    association :client

    trait :number_type do
      field_type { 'number' }
      name { 'Number of Floors' }
    end

    trait :freeform_type do
      field_type { 'freeform' }
      name { 'Building Description' }
    end

    trait :enum_type do
      field_type { 'enum' }
      name { 'Building Type' }
      
      after(:build) do |custom_field|
        custom_field.custom_field_options.build([
          { value: 'Commercial' }, 
          { value: 'Residential' },
          { value: 'Mixed Use' }
        ])
      end

      after(:create) do |custom_field|
        custom_field.custom_field_options.each(&:save!) unless custom_field.custom_field_options.any?(&:persisted?)
      end
    end
  end
end
