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

ActiveRecord::Schema[7.1].define(version: 2024_07_16_002312) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "document_number"
    t.boolean "super_admin", default: false
    t.index ["document_number"], name: "index_admins_on_document_number", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "associated_condos", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.integer "condo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_associated_condos_on_admin_id"
  end

  create_table "base_fees", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "interest_rate"
    t.integer "late_fine_cents"
    t.boolean "limited", default: false
    t.date "charge_day"
    t.integer "recurrence", default: 0
    t.integer "condo_id"
    t.integer "installments"
    t.integer "status", default: 0
  end

  create_table "bills", force: :cascade do |t|
    t.integer "unit_id"
    t.date "issue_date"
    t.date "due_date"
    t.integer "total_value_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "common_area_fees", force: :cascade do |t|
    t.integer "value_cents"
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "common_area_id"
    t.integer "condo_id"
    t.index ["admin_id"], name: "index_common_area_fees_on_admin_id"
  end

  create_table "property_owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_number"
    t.index ["document_number"], name: "index_property_owners_on_document_number", unique: true
    t.index ["email"], name: "index_property_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_property_owners_on_reset_password_token", unique: true
  end

  create_table "shared_fee_fractions", force: :cascade do |t|
    t.integer "value_cents"
    t.integer "shared_fee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_id"
    t.index ["shared_fee_id"], name: "index_shared_fee_fractions_on_shared_fee_id"
  end

  create_table "shared_fees", force: :cascade do |t|
    t.string "description"
    t.date "issue_date"
    t.integer "total_value_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "condo_id"
    t.integer "status", default: 0
  end

  create_table "single_charges", force: :cascade do |t|
    t.integer "unit_id"
    t.integer "value_cents"
    t.date "issue_date"
    t.string "description"
    t.integer "charge_type", default: 0
    t.integer "condo_id"
    t.integer "common_area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "values", force: :cascade do |t|
    t.integer "base_fee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "price_cents"
    t.integer "unit_type_id"
    t.index ["base_fee_id"], name: "index_values_on_base_fee_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "associated_condos", "admins"
  add_foreign_key "common_area_fees", "admins"
  add_foreign_key "shared_fee_fractions", "shared_fees"
  add_foreign_key "values", "base_fees"
end
