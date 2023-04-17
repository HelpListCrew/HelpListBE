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

ActiveRecord::Schema[7.0].define(version: 2023_04_17_201209) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "donor_items", force: :cascade do |t|
    t.bigint "wishlist_item_id", null: false
    t.bigint "donor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donor_id"], name: "index_donor_items_on_donor_id"
    t.index ["wishlist_item_id"], name: "index_donor_items_on_wishlist_item_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "street_address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "email"
    t.string "phone_number"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "user_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid", default: "57255e32c2848391fcb4b1b00f511a"
    t.string "username"
  end

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "recipient_id", null: false
    t.string "api_item_id"
    t.boolean "purchased", default: false
    t.boolean "received", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_path"
    t.string "name"
    t.float "price"
    t.string "size"
    t.index ["recipient_id"], name: "index_wishlist_items_on_recipient_id"
  end

  add_foreign_key "donor_items", "users", column: "donor_id"
  add_foreign_key "donor_items", "wishlist_items"
  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "wishlist_items", "users", column: "recipient_id"
end
