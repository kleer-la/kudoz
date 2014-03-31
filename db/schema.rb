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

ActiveRecord::Schema.define(:version => 18) do

  create_table "accounts", :force => true do |t|
    t.integer  "balance"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "team_id"
  end

  create_table "feedback_cycle_positions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feedback_cycle_id"
    t.integer  "received_kudoz"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "feedback_cycles", :force => true do |t|
    t.integer  "team_id"
    t.datetime "started_on"
    t.datetime "finished_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "guest_email"
    t.string   "message"
    t.boolean  "acepted"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transfers", :force => true do |t|
    t.integer  "origin_account_id"
    t.integer  "destination_account_id"
    t.string   "message"
    t.integer  "ammount"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "notified",               :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "image_url"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.boolean  "needs_initialization"
    t.string   "twitter"
    t.string   "mood"
    t.boolean  "is_kudozio"
  end

end
