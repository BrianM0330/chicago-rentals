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

ActiveRecord::Schema[8.1].define(version: 2026_05_12_120000) do
  create_table "bookmarks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_bookmarks_on_pin_id"
    t.index ["user_id", "pin_id"], name: "index_bookmarks_on_user_id_and_pin_id", unique: true
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.string "display_name"
    t.decimal "latitude", null: false
    t.integer "locality_id", null: false
    t.decimal "longitude", null: false
    t.string "postal_code", null: false
    t.string "state", null: false
    t.string "street", null: false
    t.string "street_number", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_buildings_on_latitude_and_longitude"
    t.index ["locality_id"], name: "index_buildings_on_locality_id"
    t.check_constraint "latitude >= -90 AND latitude <= 90", name: "buildings_latitude_range"
    t.check_constraint "longitude >= -180 AND longitude <= 180", name: "buildings_longitude_range"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.string "relationship"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_comments_on_pin_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "localities", force: :cascade do |t|
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "state", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_localities_on_name"
    t.index ["slug"], name: "index_localities_on_slug", unique: true
  end

  create_table "pin_flags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "pin_id", null: false
    t.string "reason", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["pin_id"], name: "index_pin_flags_on_pin_id"
    t.index ["user_id", "pin_id", "reason"], name: "index_pin_flags_on_user_id_and_pin_id_and_reason", unique: true
    t.index ["user_id"], name: "index_pin_flags_on_user_id"
  end

  create_table "pins", force: :cascade do |t|
    t.integer "bedrooms"
    t.integer "broker_fee_cents"
    t.integer "building_id"
    t.integer "comments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "flags_count", default: 0, null: false
    t.string "hood", null: false
    t.string "kind", default: "rent", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.integer "listed_rent_cents"
    t.integer "locality_id", null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.integer "move_in_year"
    t.text "note"
    t.boolean "parking_included", default: false, null: false
    t.integer "rent_cents"
    t.boolean "rent_controlled", default: false, null: false
    t.boolean "rent_stabilized", default: false, null: false
    t.date "reported_on", null: false
    t.string "slug", null: false
    t.string "source"
    t.integer "square_feet"
    t.text "tags"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.boolean "utilities_included", default: false, null: false
    t.index ["bedrooms"], name: "index_pins_on_bedrooms"
    t.index ["building_id"], name: "index_pins_on_building_id"
    t.index ["latitude", "longitude"], name: "index_pins_on_latitude_and_longitude"
    t.index ["locality_id"], name: "index_pins_on_locality_id"
    t.index ["rent_cents"], name: "index_pins_on_rent_cents"
    t.index ["reported_on"], name: "index_pins_on_reported_on"
    t.index ["slug"], name: "index_pins_on_slug", unique: true
    t.index ["user_id"], name: "index_pins_on_user_id"
    t.check_constraint "kind = 'discussion' OR (rent_cents IS NOT NULL AND rent_cents > 0)", name: "pins_rent_required_for_rent"
    t.check_constraint "kind IN ('rent', 'discussion')", name: "pins_kind_valid"
    t.check_constraint "latitude >= -90 AND latitude <= 90", name: "pins_latitude_range"
    t.check_constraint "longitude >= -180 AND longitude <= 180", name: "pins_longitude_range"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "bookmarks", "pins"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "buildings", "localities"
  add_foreign_key "comments", "pins"
  add_foreign_key "comments", "users"
  add_foreign_key "pin_flags", "pins"
  add_foreign_key "pin_flags", "users"
  add_foreign_key "pins", "buildings"
  add_foreign_key "pins", "localities"
  add_foreign_key "pins", "users"
  add_foreign_key "sessions", "users"
end
