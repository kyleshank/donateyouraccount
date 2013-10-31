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

ActiveRecord::Schema.define(:version => 20131030161640) do

  create_table "accounts", :force => true do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.integer  "followers"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "description"
    t.string   "location"
    t.string   "profile_sidebar_border_color"
    t.string   "profile_sidebar_fill_color"
    t.string   "profile_link_color"
    t.string   "profile_image_url"
    t.string   "profile_background_color"
    t.string   "profile_background_image_url"
    t.string   "profile_text_color"
    t.boolean  "profile_background_tile"
    t.boolean  "profile_use_background_image"
    t.string   "type"
    t.text     "facebook_pages"
    t.string   "refresh_token"
    t.datetime "expires_at"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "twitter_account_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.integer  "facebook_account_id"
    t.string   "facebook_page_uid"
    t.string   "name"
    t.text     "facebook_page"
    t.string   "domain"
    t.boolean  "premium",             :default => false
    t.integer  "levels",              :default => 0
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "donated_statuses", :force => true do |t|
    t.integer  "donation_id"
    t.integer  "status_id"
    t.datetime "created_at"
  end

  create_table "donations", :force => true do |t|
    t.integer  "account_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.integer  "level"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "body"
    t.string   "uid"
    t.datetime "created_at"
    t.integer  "level"
    t.string   "type"
    t.text     "data"
  end

end
