FactoryBot.define do
  factory :custom_field_option do
    sequence(:value) { |n| "Option #{n}" }
    
    association :custom_field, factory: [:custom_field, :enum_type]

    trait :building_types do
      value { ['Commercial', 'Residential', 'Mixed Use'].sample }
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