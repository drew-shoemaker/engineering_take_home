FactoryBot.define do
  factory :custom_field_value do
    association :building
    association :custom_field

    value do
      case custom_field.field_type
      when 'number'
        rand(1..100).to_s
      when 'freeform'
        "Sample text value #{rand(1..100)}"
      when 'enum'
        custom_field.custom_field_options.sample&.value || 
          create(:custom_field_option, custom_field: custom_field).value
      end
    end
  end
end

