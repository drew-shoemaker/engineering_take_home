class CreateCustomFieldOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_field_options do |t|
      t.string :value
      t.references :custom_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
