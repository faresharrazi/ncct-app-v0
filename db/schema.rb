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

ActiveRecord::Schema[8.0].define(version: 2024_12_04_143920) do
  create_table "accounts", force: :cascade do |t|
    t.string "title"
    t.float "balance", default: 0.0
    t.integer "percentage"
    t.integer "general_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "allocated_balance"
    t.index ["general_account_id"], name: "index_accounts_on_general_account_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_categories_on_account_id"
  end

  create_table "general_accounts", force: :cascade do |t|
    t.float "net_income"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "general_expenses", force: :cascade do |t|
    t.string "title"
    t.float "amount"
    t.integer "general_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["general_account_id"], name: "index_general_expenses_on_general_account_id"
  end

  create_table "general_incomes", force: :cascade do |t|
    t.string "title"
    t.float "amount"
    t.integer "general_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["general_account_id"], name: "index_general_incomes_on_general_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "name"
    t.float "amount"
    t.datetime "date"
    t.integer "account_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  add_foreign_key "accounts", "general_accounts"
  add_foreign_key "categories", "accounts"
  add_foreign_key "general_expenses", "general_accounts"
  add_foreign_key "general_incomes", "general_accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
end
