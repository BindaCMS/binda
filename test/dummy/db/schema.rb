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

ActiveRecord::Schema.define(version: 20170327134634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "binda_categories", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "slug"
    t.integer  "structure_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["slug"], name: "index_binda_categories_on_slug", unique: true, using: :btree
    t.index ["structure_id"], name: "index_binda_categories_on_structure_id", using: :btree
  end

  create_table "binda_categories_pages", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "page_id"
    t.index ["category_id"], name: "index_binda_categories_pages_on_category_id", using: :btree
    t.index ["page_id"], name: "index_binda_categories_pages_on_page_id", using: :btree
  end

  create_table "binda_field_groups", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "slug"
    t.text     "description"
    t.integer  "position"
    t.string   "layout"
    t.integer  "structure_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["slug"], name: "index_binda_field_groups_on_slug", unique: true, using: :btree
    t.index ["structure_id"], name: "index_binda_field_groups_on_structure_id", using: :btree
  end

  create_table "binda_field_settings", force: :cascade do |t|
    t.string   "name",           null: false
    t.string   "slug"
    t.text     "description"
    t.integer  "position"
    t.boolean  "required"
    t.text     "default_text"
    t.string   "field_type"
    t.integer  "field_group_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["field_group_id"], name: "index_binda_field_settings_on_field_group_id", using: :btree
    t.index ["slug"], name: "index_binda_field_settings_on_slug", unique: true, using: :btree
  end

  create_table "binda_pages", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "slug"
    t.string   "publish_state"
    t.integer  "position"
    t.integer  "structure_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["slug"], name: "index_binda_pages_on_slug", unique: true, using: :btree
    t.index ["structure_id"], name: "index_binda_pages_on_structure_id", using: :btree
  end

  create_table "binda_settings", force: :cascade do |t|
    t.string  "name",     null: false
    t.string  "slug"
    t.text    "content"
    t.integer "position"
    t.index ["slug"], name: "index_binda_settings_on_slug", unique: true, using: :btree
  end

  create_table "binda_structures", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_binda_structures_on_slug", unique: true, using: :btree
  end

  create_table "binda_texts", force: :cascade do |t|
    t.text     "content"
    t.integer  "position"
    t.integer  "field_setting_id"
    t.string   "fieldable_type"
    t.integer  "fieldable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["field_setting_id"], name: "index_binda_texts_on_field_setting_id", using: :btree
    t.index ["fieldable_type", "fieldable_id"], name: "index_binda_texts_on_fieldable_type_and_fieldable_id", using: :btree
  end

  create_table "binda_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_binda_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_binda_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

end
