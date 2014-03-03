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

ActiveRecord::Schema.define(:version => 20140302091921) do

  create_table "bm_records", :force => true do |t|
    t.integer  "ruby_version_id"
    t.integer  "test_date_id"
    t.integer  "test_name_id"
    t.float    "user"
    t.float    "system"
    t.float    "total"
    t.float    "real"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "bm_ruby_versions", :force => true do |t|
    t.string   "ruby_version"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "bm_test_dates", :force => true do |t|
    t.time     "run_date_time"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "bm_test_names", :force => true do |t|
    t.string   "test_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
