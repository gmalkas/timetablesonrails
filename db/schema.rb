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

ActiveRecord::Schema.define(:version => 20120419120952) do

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.integer  "duration"
    t.integer  "groups"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "activities_candidates", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "candidate_id"
  end

  create_table "activities_teachers", :id => false, :force => true do |t|
    t.integer "activity_id"
    t.integer "teacher_id"
  end

  create_table "candidates_courses", :id => false, :force => true do |t|
    t.integer "candidate_id"
    t.integer "course_id"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "semester_id"
    t.integer  "manager_id"
  end

  create_table "notification_properties", :force => true do |t|
    t.string  "name"
    t.string  "value"
    t.integer "notification_id"
    t.string  "resource"
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.string   "style"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "school_years", :force => true do |t|
    t.boolean  "archived",   :default => false
    t.boolean  "activated",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "semesters", :force => true do |t|
    t.string  "name"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "school_year_id"
  end

  create_table "users", :force => true do |t|
    t.string   "password_digest"
    t.string   "status"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "session_token"
    t.string   "username"
    t.boolean  "administrator",   :default => false
    t.string   "firstname"
    t.string   "lastname"
  end

end
