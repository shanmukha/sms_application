class CreateExamSubjects < ActiveRecord::Migration
  def self.up
    create_table :exam_subjects do |t|
      t.integer :exam_id
      t.integer :group_id
      t.integer :academic_year_id
      t.integer :maximum_marks
      t.integer :passing_marks
      t.boolean :use_grade

      t.timestamps
    end
  end

  def self.down
    drop_table :exam_subjects
  end
end
