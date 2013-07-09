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

ActiveRecord::Schema.define(:version => 20130709110436) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "instance_id"
    t.text     "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "comments", ["instance_id"], :name => "index_comments_on_instance_id"

  create_table "messages", :force => true do |t|
    t.text     "text"
    t.integer  "sender_id"
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "read",        :default => false
    t.string   "sender_name"
  end

  create_table "puzzle_instances", :force => true do |t|
    t.string   "fen"
    t.integer  "rating"
    t.string   "lines"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "puzzle_id"
    t.string   "solution"
    t.string   "description"
  end

  add_index "puzzle_instances", ["puzzle_id"], :name => "index_puzzle_instances_on_puzzle_id"

  create_table "puzzles", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "puzzle_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
    t.integer  "difficulty"
    t.integer  "streak"
    t.float    "ratio"
  end

  create_table "stats", :force => true do |t|
    t.integer  "streak",          :default => 0
    t.integer  "life_attempts",   :default => 0
    t.integer  "life_solved",     :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "user_id"
    t.integer  "puzzle_id"
    t.boolean  "solved",          :default => false
    t.integer  "recent_attempts"
    t.integer  "recent_solved"
  end

  add_index "stats", ["puzzle_id"], :name => "index_stats_on_puzzle_id"
  add_index "stats", ["user_id"], :name => "index_stats_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "username"
    t.boolean  "admin",                                 :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
