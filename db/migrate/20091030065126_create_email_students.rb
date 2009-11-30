class CreateEmailStudents < ActiveRecord::Migration
  def self.up
    create_table :email_students do |t|
      t.integer :email_id
      t.integer :student_id

      t.timestamps
    end
  end

  def self.down
    drop_table :email_students
  end
end
