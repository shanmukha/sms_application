class CreateStudentSubjects < ActiveRecord::Migration
  def self.up
    create_table :student_subjects do |t|
        t.integer :student_id
       t.integer :subject_id
    
      t.timestamps
    end
  end

  def self.down
    drop_table :student_subjects
  end
end
