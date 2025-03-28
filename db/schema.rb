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

ActiveRecord::Schema[8.0].define(version: 2025_03_28_102803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "order_type", default: 0, null: false
    t.integer "order_side", default: 0, null: false
    t.string "base_currency", null: false
    t.string "base_address", null: false
    t.string "quote_currency", null: false
    t.string "quote_address", null: false
    t.decimal "send_amount", precision: 20, scale: 8, null: false
    t.decimal "receive_amount", precision: 20, scale: 8, null: false
    t.decimal "price", precision: 20, scale: 8, null: false
    t.decimal "fee", precision: 20, scale: 8, null: false
    t.decimal "miner_fee", precision: 20, scale: 8, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "txid"
    t.integer "confirmations", default: 0
    t.integer "retries", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_transactions_on_order_id"
    t.index ["txid"], name: "index_transactions_on_txid"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.boolean "admin_role", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "orders", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "transactions", "orders"
end
