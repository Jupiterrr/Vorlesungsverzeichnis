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

ActiveRecord::Schema.define(:version => 20141231142256) do

  create_table "boards", :force => true do |t|
    t.integer "postable_id"
    t.string  "postable_type"
    t.hstore  "data",          :null => false
  end

  add_index "boards", ["postable_id"], :name => "index_boards_on_postable_id"

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.hstore   "data",             :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

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
    t.hstore   "data",       :null => false
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
    t.hstore   "data",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_activities", ["event_id"], :name => "index_event_activities_on_event_id"

  create_table "event_dates", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "room_name"
    t.string   "type"
    t.integer  "event_id"
    t.string   "uuid"
    t.datetime "api_last_modified"
    t.hstore   "data",              :null => false
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "relation"
    t.string   "term"
    t.string   "data_source"
  end

  add_index "event_dates", ["event_id"], :name => "index_event_dates_on_event_id"
  add_index "event_dates", ["room_id"], :name => "index_event_dates_on_room_id"
  add_index "event_dates", ["uuid"], :name => "index_event_dates_on_uuid"

  create_table "event_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.hstore   "data",       :null => false
    t.datetime "deleted_at"
  end

  add_index "event_subscriptions", ["deleted_at"], :name => "index_event_subscriptions_on_deleted_at"
  add_index "event_subscriptions", ["user_id", "event_id"], :name => "index_events_users_on_user_id_and_event_id"

  create_table "events", :force => true do |t|
    t.string   "orginal_no"
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
    t.hstore   "linker_attributes", :null => false
    t.hstore   "data",              :null => false
    t.text     "user_text_md"
    t.string   "no"
    t.string   "data_source"
  end

  add_index "events", ["external_id"], :name => "index_events_on_external_id"

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
    t.hstore   "data",          :null => false
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

  add_index "poi_groups_pois", ["poi_group_id", "poi_id"], :name => "index_poi_groups_pois_on_poi_group_id_and_poi_id"

  create_table "pois", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.string   "building_no"
    t.string   "address"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_source"
    t.hstore   "data"
  end

  create_table "posts", :force => true do |t|
    t.integer  "author_id"
    t.integer  "board_id"
    t.text     "text"
    t.string   "content_type"
    t.hstore   "data",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["board_id"], :name => "index_posts_on_board_id"

  create_table "rooms", :force => true do |t|
    t.integer  "poi_id"
    t.string   "uuid"
    t.string   "name"
    t.hstore   "data",        :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "data_source"
  end

  add_index "rooms", ["poi_id"], :name => "index_rooms_on_poi_id"

  create_table "sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.hstore   "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["token"], :name => "index_sessions_on_token"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "timetable_id"
    t.hstore   "data",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["timetable_id"], :name => "index_users_on_timetable_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "vvzs", :force => true do |t|
    t.string   "name"
    t.string   "ancestry"
    t.string   "external_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_leaf",        :default => false
    t.integer  "ancestry_depth", :default => 0
    t.string   "data_source"
  end

  add_index "vvzs", ["ancestry"], :name => "index_vvzs_on_ancestry"
  add_index "vvzs", ["external_id"], :name => "index_vvzs_on_external_id"

end
