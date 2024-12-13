# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_12_11_220752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.string "address"
    t.string "state"
    t.string "city"
    t.string "zip"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_buildings_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_clients_on_name"
  end

  create_table "custom_field_options", force: :cascade do |t|
    t.string "value"
    t.bigint "custom_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id"], name: "index_custom_field_options_on_custom_field_id"
  end

  create_table "custom_field_values", force: :cascade do |t|
    t.string "value"
    t.bigint "building_id", null: false
    t.bigint "custom_field_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_custom_field_values_on_building_id"
    t.index ["custom_field_id"], name: "index_custom_field_values_on_custom_field_id"
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string "name"
    t.string "field_type"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_custom_fields_on_client_id"
  end

  add_foreign_key "buildings", "clients"
  add_foreign_key "custom_field_options", "custom_fields"
  add_foreign_key "custom_field_values", "buildings"
  add_foreign_key "custom_field_values", "custom_fields"
  add_foreign_key "custom_fields", "clients"
end