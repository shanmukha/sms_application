class CreateLetterStudents < ActiveRecord::Migration
  def self.up
    create_table :letter_students do |t|
      t.integer :letter_id
      t.integer :student_id
       t.timestamps
    end
  end

  def self.down
    drop_table :letter_students
  end
end
