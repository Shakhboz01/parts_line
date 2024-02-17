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

ActiveRecord::Schema[7.0].define(version: 2024_02_17_132345) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "comment"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
    t.decimal "debt_in_usd"
    t.decimal "debt_in_uzs"
  end

  create_table "combination_of_local_products", force: :cascade do |t|
    t.string "comment"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_conversions", force: :cascade do |t|
    t.decimal "rate", precision: 9, scale: 2
    t.boolean "to_uzs", default: true
    t.bigint "user_id", null: false
    t.decimal "price_in_uzs", precision: 18, scale: 2
    t.decimal "price_in_usd", precision: 18, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_currency_conversions_on_user_id"
  end

  create_table "currency_rates", force: :cascade do |t|
    t.decimal "rate", precision: 12, scale: 2
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_transaction_reports", force: :cascade do |t|
    t.decimal "income_in_usd", precision: 18, scale: 2
    t.decimal "income_in_uzs", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_transaction_reports_on_user_id"
  end

  create_table "debt_operations", force: :cascade do |t|
    t.boolean "debt_in_usd", default: true
    t.integer "status", default: 0
    t.decimal "price", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.bigint "debt_user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_user_id"], name: "index_debt_operations_on_debt_user_id"
    t.index ["user_id"], name: "index_debt_operations_on_user_id"
  end

  create_table "debt_users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_from_counterparties", force: :cascade do |t|
    t.decimal "total_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "total_paid"
    t.integer "payment_type", default: 0
    t.string "comment"
    t.integer "status", default: 0
    t.bigint "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "price_in_usd", default: false
    t.boolean "with_image", default: false
    t.bigint "product_category_id"
    t.boolean "enable_to_send_sms", default: true
    t.index ["product_category_id"], name: "index_delivery_from_counterparties_on_product_category_id"
    t.index ["provider_id"], name: "index_delivery_from_counterparties_on_provider_id"
    t.index ["user_id"], name: "index_delivery_from_counterparties_on_user_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.boolean "verified", default: false
    t.boolean "price_in_usd", default: false
    t.decimal "price", precision: 15, scale: 2
    t.string "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_discounts_on_sale_id"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.bigint "combination_of_local_product_id"
    t.decimal "price", default: "0.0"
    t.decimal "total_paid"
    t.integer "expenditure_type"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.boolean "price_in_usd", default: false
    t.string "sale_ids"
    t.boolean "with_image", default: false
    t.bigint "user_id"
    t.string "comment"
    t.index ["combination_of_local_product_id"], name: "index_expenditures_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_expenditures_on_delivery_from_counterparty_id"
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "local_services", force: :cascade do |t|
    t.decimal "price", precision: 16, scale: 2
    t.string "comment"
    t.bigint "sale_from_local_service_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_from_local_service_id"], name: "index_local_services_on_sale_from_local_service_id"
    t.index ["user_id"], name: "index_local_services_on_user_id"
  end

  create_table "owners_operations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "operation_type", default: 0
    t.boolean "price_in_usd", default: true
    t.decimal "price", precision: 19, scale: 2
    t.bigint "operator_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_owners_operations_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "product_entries", force: :cascade do |t|
    t.decimal "buy_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "sell_price", precision: 10, scale: 2, default: "0.0"
    t.boolean "paid_in_usd", default: false
    t.decimal "service_price", precision: 10, scale: 2
    t.bigint "product_id", null: false
    t.decimal "amount", precision: 18, scale: 2, default: "0.0"
    t.decimal "amount_sold", precision: 18, scale: 2, default: "0.0"
    t.string "comment"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.bigint "combination_of_local_product_id"
    t.boolean "local_entry", default: false
    t.boolean "return", default: false
    t.bigint "storage_id", null: false
    t.decimal "price_in_percentage", precision: 5, scale: 2
    t.index ["combination_of_local_product_id"], name: "index_product_entries_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_product_entries_on_delivery_from_counterparty_id"
    t.index ["product_id"], name: "index_product_entries_on_product_id"
    t.index ["storage_id"], name: "index_product_entries_on_storage_id"
  end

  create_table "product_remaining_inequalities", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "amount"
    t.decimal "previous_amount"
    t.string "reason"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_remaining_inequalities_on_product_id"
    t.index ["user_id"], name: "index_product_remaining_inequalities_on_user_id"
  end

