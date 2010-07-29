class AddFieldToExamSubject < ActiveRecord::Migration
  def self.up
   add_column :exam_subjects, :to_date, :datetime
    add_column :exam_subjects, :from_date, :datetime
  end

  def self.down
  end
end
