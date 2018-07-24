# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2015_06_10_040050) do

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "category_type", null: false
    t.string "description", null: false
    t.string "group"
    t.decimal "value", precision: 11, scale: 2
    t.string "frequency", null: false
    t.boolean "disabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "investment", default: false
    t.index ["category_type"], name: "index_categories_on_category_type"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "transactions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.date "date"
    t.decimal "amount", precision: 11, scale: 2
    t.integer "category_id"
    t.string "payee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["date"], name: "index_transactions_on_date"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "users"
end
