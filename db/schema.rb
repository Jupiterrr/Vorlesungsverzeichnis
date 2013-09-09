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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130904234217) do

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "disciplines_users", :id => false, :force => true do |t|
    t.integer "discipline_id"
    t.integer "user_id"
  end

  add_index "disciplines_users", ["discipline_id", "user_id"], :name => "index_disciplines_users_on_discipline_id_and_user_id"
  add_index "disciplines_users", ["user_id", "discipline_id"], :name => "index_disciplines_users_on_user_id_and_discipline_id"

  create_table "documents", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "type"
    t.string   "file_url"
    t.hstore   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "documents", ["event_id"], :name => "index_documents_on_event_id"

  create_table "early_accesses", :force => true do |t|
    t.string   "mail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_activities", :force => true do |t|
    t.integer  "event_id"
    t.string   "action"
    t.hstore   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_activities", ["event_id"], :name => "index_event_activities_on_event_id"

  create_table "event_dates", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "room"
    t.string   "type"
    t.integer  "event_id"
    t.string   "uuid"
    t.datetime "api_last_modified"
    t.hstore   "data"
  end

  add_index "event_dates", ["event_id"], :name => "index_event_dates_on_event_id"

  create_table "events", :force => true do |t|
    t.string   "nr"
    t.text     "name"
    t.string   "_type"
    t.text     "lecturer"
    t.string   "term"
    t.text     "faculty"
    t.text     "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_id"
    t.text     "original_name"
    t.text     "user_text_md"
    t.hstore   "linker_attributes"
    t.hstore   "data"
  end

  add_index "events", ["external_id"], :name => "index_events_on_external_id"

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "event_id"
  end

  create_table "events_vvzs", :force => true do |t|
    t.integer "event_id"
    t.integer "vvz_id"
  end

  add_index "events_vvzs", ["event_id"], :name => "index_events_vvzs_on_event_id"
  add_index "events_vvzs", ["vvz_id"], :name => "index_events_vvzs_on_vvz_id"

  create_table "exam_dates", :force => true do |t|
    t.integer  "event_id"
    t.date     "date"
    t.integer  "discipline_id"
    t.hstore   "data"
    t.string   "type"
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.time     "deleted_at"
  end

  add_index "exam_dates", ["discipline_id"], :name => "index_exam_dates_on_discipline_id"
  add_index "exam_dates", ["event_id"], :name => "index_exam_dates_on_event_id"

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "poi_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poi_groups_pois", :force => true do |t|
    t.integer "poi_group_id"
    t.integer "poi_id"
  end

  create_table "pois", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.string   "building_no"
    t.string   "address"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timetable_id"
  end

  create_table "vvzs", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.string   "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_leaf",     :default => false
  end

  add_index "vvzs", ["ancestry"], :name => "index_vvzs_on_ancestry"
  add_index "vvzs", ["external_id"], :name => "index_vvzs_on_external_id"

end
