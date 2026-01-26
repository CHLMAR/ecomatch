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

ActiveRecord::Schema[7.1].define(version: 2026_01_26_154606) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.float "planet_rating"
    t.float "people_rating"
    t.float "animals_rating"
    t.float "overall_rating"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "uploaded_image"
    t.string "uploaded_link"
    t.string "system_prompt"
    t.string "clothing_item"
    t.string "clothing_material"
    t.string "clothing_colour"
    t.string "clothing_size"
    t.string "clothing_brand"
    t.float "clothing_price"
    t.string "item_image"
    t.string "item_name"
    t.text "item_description"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end
  
  add_foreign_key "searches", "users"
  
   create_table "comparison_products", force: :cascade do |t|
    t.string "clothing_item"
    t.string "external_link"
    t.text "product_description"
    t.string "item_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "brand_id", null: false
    t.index ["brand_id"], name: "index_comparison_products_on_brand_id"
   end
  
  add_foreign_key "comparison_products", "brands"

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
