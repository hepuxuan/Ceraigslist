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

ActiveRecord::Schema.define(:version => 20131109275708) do

  create_table "assets", :force => true do |t|
    t.integer  "product_info_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "crag_uri"
    t.string   "crag_thumb_uri"
  end

  create_table "category", :force => true do |t|
    t.string "name"
  end

  create_table "product_infos", :force => true do |t|
    t.integer  "user_id"
    t.datetime "post_date"
    t.integer  "category_id"
    t.integer  "source"
    t.string   "uri"
    t.integer  "product_id",  :limit => 8
    t.text     "title"
    t.text     "body"
    t.text     "address"
    t.text     "state"
    t.text     "city"
    t.float    "price"
    t.float    "longitude"
    t.float    "latitude"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "address"
    t.string "state"
    t.string "city"
    t.float  "longitude"
    t.float  "latitude"
  end

end
