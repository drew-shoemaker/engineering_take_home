FactoryBot.define do
  factory :client do
    sequence(:name) { |n| "Client #{n}" }

    trait :with_custom_fields do
      after(:create) do |client|
        create(:custom_field, :number_type, client: client)
        create(:custom_field, :freeform_type, client: client)
        create(:custom_field, :enum_type, client: client)
      end
    end
  end
end
