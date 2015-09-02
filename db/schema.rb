# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150902145806) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aggregators", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "return_type"
    t.string   "modifier"
    t.string   "operation"
    t.string   "parameters"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "data_collections", force: :cascade do |t|
    t.string   "title"
    t.json     "ordered_data_points"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "data_collections_points", force: :cascade do |t|
    t.integer "data_point_id"
    t.integer "data_collection_id"
  end

  add_index "data_collections_points", ["data_collection_id"], name: "index_data_collections_points_on_data_collection_id", using: :btree
  add_index "data_collections_points", ["data_point_id"], name: "index_data_collections_points_on_data_point_id", using: :btree

  create_table "data_collections_reports", force: :cascade do |t|
    t.integer "data_collection_id"
    t.integer "report_id"
  end

  add_index "data_collections_reports", ["data_collection_id"], name: "index_data_collections_reports_on_data_collection_id", using: :btree
  add_index "data_collections_reports", ["report_id"], name: "index_data_collections_reports_on_report_id", using: :btree

  create_table "data_points", force: :cascade do |t|
    t.string   "name"
    t.integer  "aggregator_id"
    t.json     "field_mapping"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "data_points", ["aggregator_id"], name: "index_data_points_on_aggregator_id", using: :btree

  create_table "data_points_fields", force: :cascade do |t|
    t.integer "data_point_id"
    t.integer "field_id"
  end

  add_index "data_points_fields", ["data_point_id"], name: "index_data_points_fields_on_data_point_id", using: :btree
  add_index "data_points_fields", ["field_id"], name: "index_data_points_fields_on_field_id", using: :btree

  create_table "data_points_reports", force: :cascade do |t|
    t.integer "data_point_id"
    t.integer "report_id"
  end

  add_index "data_points_reports", ["data_point_id"], name: "index_data_points_reports_on_data_point_id", using: :btree
  add_index "data_points_reports", ["report_id"], name: "index_data_points_reports_on_report_id", using: :btree

  create_table "data_sources", force: :cascade do |t|
    t.string   "database_url", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "fields", force: :cascade do |t|
    t.integer  "data_source_id"
    t.string   "name"
    t.string   "table_name"
    t.string   "column_name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "fields", ["data_source_id"], name: "index_fields_on_data_source_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.json     "geometry"
    t.json     "tags"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "completed",             default: false
    t.json     "underlying_geometries"
    t.text     "geoids",                                             array: true
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "place_id"
    t.integer  "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profiles", ["place_id"], name: "index_profiles_on_place_id", using: :btree
  add_index "profiles", ["report_id"], name: "index_profiles_on_report_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "official"
    t.json     "tags"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title"
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "data_points", "aggregators"
  add_foreign_key "fields", "data_sources"
  add_foreign_key "profiles", "places"
  add_foreign_key "profiles", "reports"
end
