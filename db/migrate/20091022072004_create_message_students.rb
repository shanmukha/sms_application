class CreateMessageStudents < ActiveRecord::Migration
  def self.up
    create_table :message_students do |t|
      t.integer :message_id
      t.integer :student_id
      t.integer :sms_id
      t.string  :status ,:default =>"Sent"
      t.timestamps
    end
  end

  def self.down
    drop_table :message_students
  end
end
