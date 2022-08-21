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

ActiveRecord::Schema[7.0].define(version: 2022_06_12_160007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "age_groups", force: :cascade do |t|
    t.bigint "event_detail_id"
    t.string "name"
    t.string "gender"
    t.integer "min_age"
    t.integer "max_age"
    t.index ["event_detail_id"], name: "index_age_groups_on_event_detail_id"
  end

  create_table "event_details", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "event_type_id"
    t.date "start_date"
    t.date "end_date"
    t.decimal "lap_distance"
    t.string "distance_units"
    t.decimal "lap_elevation"
    t.string "elevation_units"
    t.index ["event_id"], name: "index_event_details_on_event_id"
    t.index ["event_type_id"], name: "index_event_details_on_event_type_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.integer "display_order"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "locality"
    t.string "region"
    t.string "postal_code"
    t.string "country"
    t.date "date"
    t.string "latitude"
    t.string "longitude"
    t.boolean "archived"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "event_detail_id"
    t.string "bib_number"
    t.string "gender"
    t.integer "age"
    t.bigint "age_group_id"
    t.string "participation_day"
    t.integer "additional_laps"
    t.index ["age_group_id"], name: "index_participants_on_age_group_id"
    t.index ["event_detail_id"], name: "index_participants_on_event_detail_id"
    t.index ["person_id"], name: "index_participants_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "first_name"
    t.string "last_name"
  end

  create_table "result_details", force: :cascade do |t|
    t.bigint "result_id"
    t.integer "lap_number"
    t.interval "lap_time"
    t.interval "pit_time"
    t.decimal "lap_distance"
    t.string "distance_units"
    t.index ["result_id"], name: "index_result_details_on_result_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "participant_id"
    t.integer "place_overall"
    t.integer "place_gender"
    t.integer "place_age_group"
    t.integer "status"
    t.index ["participant_id"], name: "index_results_on_participant_id"
  end

  add_foreign_key "age_groups", "event_details"
  add_foreign_key "event_details", "event_types"
  add_foreign_key "event_details", "events"
  add_foreign_key "participants", "age_groups"
  add_foreign_key "participants", "event_details"
  add_foreign_key "participants", "people"
  add_foreign_key "result_details", "results"
  add_foreign_key "results", "participants"
end
