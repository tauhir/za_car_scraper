# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_08_092033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "body_types", force: :cascade do |t|
    t.string "name"
    t.string "cars_coza"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "makers", force: :cascade do |t|
    t.string "name"
    t.string "cars_coza"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.string "transmission"
    t.string "fuel_type"
    t.string "make"
    t.string "model"
    t.string "url"
    t.integer "year"
    t.integer "price"
    t.integer "miles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
  end

end
