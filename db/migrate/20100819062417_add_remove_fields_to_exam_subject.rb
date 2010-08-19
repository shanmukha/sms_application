class AddRemoveFieldsToExamSubject < ActiveRecord::Migration
  def self.up
  add_column :exam_subjects, :exam_date, :date
  add_column :exam_subjects, :from_time, :time
  add_column :exam_subjects, :to_time, :time
  remove_column :exam_subjects, :to_date
  remove_column :exam_subjects, :from_date
  end

  def self.down
  end
end
