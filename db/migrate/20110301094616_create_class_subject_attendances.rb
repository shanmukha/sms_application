class CreateClassSubjectAttendances < ActiveRecord::Migration
  def self.up
    create_table :class_subject_attendances do |t|
      t.integer :group_id
      t.date :date
      t.integer :subject_id
      t.timestamps
    end
  end

  def self.down
    drop_table :class_subject_attendances
  end
end
