class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.integer :group_id
      t.string :exam_type
      t.date :conducted_on
      t.integer :maximum_marks
      t.integer :subject_id
      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end
