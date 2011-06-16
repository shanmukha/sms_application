class AddAcademicIdClassSubjectAttendance < ActiveRecord::Migration
  def self.up
  add_column :class_subject_attendances,:academic_year_id, :integer
  end

  def self.down
    remove_column :class_subject_attendances,:academic_year_id, :integer
  end
end
