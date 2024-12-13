require 'faker'

puts "Clearing existing data..."
CustomFieldValue.destroy_all
CustomFieldOption.destroy_all
CustomField.destroy_all
Building.destroy_all
Client.destroy_all

# Create clients with more realistic names using Faker
puts "Creating clients..."
clients = [
  "#{Faker::Company.name} Properties",
  "#{Faker::Company.name} Development",
  "#{Faker::Company.name} Buildings LLC",
  "#{Faker::Company.name} Real Estate",
  "#{Faker::Company.name} Construction"
].map { |name| Client.create!(name: name) }

puts "Creating custom fields..."
clients.each do |client|
  case client.name
  when /Properties$/
    CustomField.create!(name: "Monthly Revenue", field_type: "number", client: client)
    CustomField.create!(name: "Tenant Mix", field_type: "freeform", client: client)
    enum_field = CustomField.new(name: "Market Segment", field_type: "enum", client: client)
    enum_field.custom_field_options.build([
      { value: "High End" }, { value: "Mid Market" }, { value: "Budget" }
    ])
    enum_field.save!

  when /Development$/
    CustomField.create!(name: "Construction Cost", field_type: "number", client: client)
    CustomField.create!(name: "Project Timeline", field_type: "freeform", client: client)
    enum_field = CustomField.new(name: "Development Phase", field_type: "enum", client: client)
    enum_field.custom_field_options.build([
      { value: "Planning" }, { value: "Construction" }, { value: "Complete" }
    ])
    enum_field.save!

  when /Buildings LLC$/
    CustomField.create!(name: "Maintenance Budget", field_type: "number", client: client)
    CustomField.create!(name: "Building History", field_type: "freeform", client: client)
    enum_field = CustomField.new(name: "Building Category", field_type: "enum", client: client)
    enum_field.custom_field_options.build([
      { value: "Office" }, { value: "Retail" }, { value: "Mixed" }
    ])
    enum_field.save!

  when /Real Estate$/
    CustomField.create!(name: "Market Value", field_type: "number", client: client)
    CustomField.create!(name: "Recent Renovations", field_type: "freeform", client: client)
    enum_field = CustomField.new(name: "Investment Grade", field_type: "enum", client: client)
    enum_field.custom_field_options.build([
      { value: "Grade A" }, { value: "Grade B" }, { value: "Grade C" }
    ])
    enum_field.save!

  when /Construction$/
    CustomField.create!(name: "Square Footage", field_type: "number", client: client)
    CustomField.create!(name: "Construction Notes", field_type: "freeform", client: client)
    enum_field = CustomField.new(name: "Building Style", field_type: "enum", client: client)
    enum_field.custom_field_options.build([
      { value: "Modern" }, { value: "Classical" }, { value: "Industrial" }
    ])
    enum_field.save!
  end
end

puts "Creating buildings..."
clients.each do |client|
  3.times do
    building = Building.create!(
      address: Faker::Address.street_address,
      state: Faker::Address.state_abbr,
      city: Faker::Address.city,
      zip: Faker::Address.zip_code,
      client: client
    )

    client.custom_fields.each do |field|
      value = case field.field_type
      when "number"
        case field.name
        when "Monthly Revenue"
          rand(50000..500000).to_s
        when "Construction Cost"
          rand(1000000..10000000).to_s
        when "Maintenance Budget"
          rand(10000..100000).to_s
        when "Market Value"
          rand(2000000..20000000).to_s
        when "Square Footage"
          rand(5000..50000).to_s
        end
      when "freeform"
        case field.name
        when "Tenant Mix"
          "#{Faker::Company.name}, #{Faker::Company.industry}"
        when "Project Timeline"
          "#{Faker::Date.forward(days: 365)} completion target"
        when "Building History"
          "Built in #{rand(1900..2000)}. #{Faker::Company.catch_phrase}"
        when "Recent Renovations"
          "#{Faker::Construction.trade} - #{Faker::Date.backward(days: 365)}"
        when "Construction Notes"
          Faker::Construction.subcontract_category
        end
      when "enum"
        field.custom_field_options.sample.value
      end

      CustomFieldValue.create!(
        value: value,
        building: building,
        custom_field: field
      )
    end
  end
end

puts "Seed completed successfully!"
