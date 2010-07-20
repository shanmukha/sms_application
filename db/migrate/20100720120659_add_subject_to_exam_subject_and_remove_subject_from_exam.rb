class AddSubjectToExamSubjectAndRemoveSubjectFromExam < ActiveRecord::Migration
  def self.up
    add_column :exam_subjects, :subject_id, :integer
    remove_column :exams, :subject_id
  end

  def self.down
  end
end
