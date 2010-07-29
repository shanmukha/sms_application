class AddFieldsToExam < ActiveRecord::Migration
  def self.up
    add_column :exams, :to_date, :date
    add_column :exams, :from_date, :date
    remove_column :exams, :conducted_on
  end

  def self.down
  end
end
