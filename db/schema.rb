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

ActiveRecord::Schema.define(:version => 20100731002842) do

  create_table "blogs", :force => true do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "feed_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "name"
    t.string   "search_query"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "source_id"
    t.string   "url"
    t.string   "categories"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["source_id"], :name => "index_feeds_on_source_id"

  create_table "quotes", :force => true do |t|
    t.text     "body"
    t.string   "quoted"
    t.integer  "thing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", :force => true do |t|
    t.string   "slug"
    t.string   "name"
    t.text     "description"
    t.string   "home_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["home_url"], :name => "index_sources_on_home_url"
  add_index "sources", ["slug"], :name => "index_sources_on_slug"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                            :null => false
    t.integer  "taggable_id",                       :null => false
    t.string   "taggable_type",                     :null => false
    t.datetime "created_at"
    t.string   "context",       :default => "tags"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id"
  add_index "taggings", ["taggable_type"], :name => "index_taggings_on_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name",         :null => false
    t.string "special_type"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "things", :force => true do |t|
    t.string   "external_id"
    t.string   "title"
    t.text     "summary"
    t.string   "old_source"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "external_data"
    t.boolean  "delta"
    t.text     "extended_body"
    t.text     "tag_list"
    t.string   "parent_category"
    t.integer  "blog_id"
    t.integer  "source_id"
    t.integer  "feed_id"
    t.string   "cached_related_count"
  end

  add_index "things", ["created_at"], :name => "index_things_on_created_at"
  add_index "things", ["link"], :name => "index_things_on_link"
  add_index "things", ["old_source", "created_at"], :name => "index_things_on_source_and_created_at"
  add_index "things", ["old_source"], :name => "index_things_on_source"
  add_index "things", ["parent_category", "created_at"], :name => "index_things_on_parent_category_and_created_at"
  add_index "things", ["parent_category"], :name => "index_things_on_parent_category"
  add_index "things", ["source_id"], :name => "index_things_on_source_id"

  create_table "trends", :force => true do |t|
    t.text     "data"
    t.date     "day"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
