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

ActiveRecord::Schema[7.1].define(version: 2024_06_27_214305) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "base_fees", force: :cascade do |t|
    t.decimal "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "common_area_fee_histories", force: :cascade do |t|
    t.integer "fee"
    t.string "user"
    t.integer "common_area_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["common_area_id"], name: "index_common_area_fee_histories_on_common_area_id"
  end

  create_table "common_areas", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "max_capacity"
    t.string "usage_rules"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fee", default: 0
    t.index ["condo_id"], name: "index_common_areas_on_condo_id"
  end

  create_table "condos", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_fees", force: :cascade do |t|
    t.decimal "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "property_owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_property_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_property_owners_on_reset_password_token", unique: true
  end

  create_table "shared_fee_fractions", force: :cascade do |t|
    t.integer "value_cents"
    t.integer "shared_fee_id", null: false
    t.integer "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shared_fee_id"], name: "index_shared_fee_fractions_on_shared_fee_id"
    t.index ["unit_id"], name: "index_shared_fee_fractions_on_unit_id"
  end

  create_table "shared_fees", force: :cascade do |t|
    t.string "description"
    t.date "issue_date"
    t.integer "total_value_cents"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condo_id"], name: "index_shared_fees_on_condo_id"
  end

  create_table "unit_types", force: :cascade do |t|
    t.string "description"
    t.integer "area"
    t.float "ideal_fraction"
    t.integer "condo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condo_id"], name: "index_unit_types_on_condo_id"
  end

  create_table "units", force: :cascade do |t|
    t.integer "area"
    t.integer "floor"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_type_id", null: false
    t.index ["unit_type_id"], name: "index_units_on_unit_type_id"
  end

  add_foreign_key "common_area_fee_histories", "common_areas"
  add_foreign_key "common_areas", "condos"
  add_foreign_key "shared_fee_fractions", "shared_fees"
  add_foreign_key "shared_fee_fractions", "units"
  add_foreign_key "shared_fees", "condos"
  add_foreign_key "unit_types", "condos"
  add_foreign_key "units", "unit_types"
end
