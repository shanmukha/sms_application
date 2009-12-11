class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
       t.integer :group_id
       t.date :scheduled_date
       t.text :message_body
       t.time :scheduled_time
       t.integer :user_id
       t.string  :number
       t.string  :status
       t.integer :sms_id
       t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
