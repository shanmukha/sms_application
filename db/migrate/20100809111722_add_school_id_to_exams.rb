class AddSchoolIdToExams < ActiveRecord::Migration
  def self.up
  add_column :exams, :school_id, :integer
  end

  def self.down
  end
end
