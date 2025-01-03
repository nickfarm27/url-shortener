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

ActiveRecord::Schema[7.1].define(version: 2024_10_29_150943) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clicks", force: :cascade do |t|
    t.bigint "shortened_url_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "geolocation_id"
    t.index ["geolocation_id"], name: "index_clicks_on_geolocation_id"
    t.index ["shortened_url_id"], name: "index_clicks_on_shortened_url_id"
  end

  create_table "counters", force: :cascade do |t|
    t.bigint "value", default: 0, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_counters_on_name", unique: true
  end

  create_table "geolocations", force: :cascade do |t|
    t.string "ip_address", null: false
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_geolocations_on_ip_address", unique: true
  end

  create_table "shortened_urls", force: :cascade do |t|
    t.string "path", null: false
    t.string "target_url", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_shortened_urls_on_path", unique: true
  end

  add_foreign_key "clicks", "geolocations"
  add_foreign_key "clicks", "shortened_urls"
end
