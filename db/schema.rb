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

ActiveRecord::Schema.define(version: 2020_02_03_085131) do

  create_table "tested_urls", force: :cascade do |t|
    t.string "url"
    t.float "ttfb"
    t.float "tti"
    t.float "ttfp"
    t.float "speed_index"
    t.boolean "passed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_tested_urls_on_created_at"
    t.index ["url"], name: "index_tested_urls_on_url"
  end

end
