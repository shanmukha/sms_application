class CreateScheduleStudents < ActiveRecord::Migration
  def self.up
    create_table :schedule_students do |t|
      t.integer :schedule_id
      t.integer :student_id
      t.integer :sms_id
      t.string  :status ,:default =>"Scheduled"
      t.timestamps
    end
  end

  def self.down
    drop_table :schedule_students
  end
end
