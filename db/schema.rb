# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091103110047) do

  create_table "email_students", :force => true do |t|
    t.integer  "email_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.text     "body"
    t.string   "subject"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "status",     :default => "Active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_students", :id => false, :force => true do |t|
    t.integer  "group_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letter_students", :force => true do |t|
    t.integer  "letter_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_students", :force => true do |t|
    t.integer  "message_id"
    t.integer  "student_id"
    t.integer  "sms_id"
    t.string   "status",     :default => "Sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "message_templates", :force => true do |t|
    t.text     "message_body"
    t.string   "message_title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "group_id"
    t.text     "message_body"
    t.integer  "user_id"
    t.string   "number"
    t.string   "status"
    t.integer  "sms_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "schedule_students", :force => true do |t|
    t.integer  "schedule_id"
    t.integer  "student_id"
    t.integer  "sms_id"
    t.string   "status",      :default => "Scheduled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "group_id"
    t.date     "scheduled_date"
    t.text     "message_body"
    t.time     "scheduled_time"
    t.integer  "user_id"
    t.string   "number"
    t.string   "status"
    t.integer  "sms_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "name"
    t.string   "parent"
    t.string   "number"
    t.text     "address"
    t.string   "email"
    t.string   "roll_number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "designation"
    t.string   "crypted_password"
    t.string   "mail_id"
    t.string   "balance",           :default => "0"
    t.string   "server_user_name"
    t.string   "server_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
