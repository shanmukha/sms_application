class CreateClassSubjects < ActiveRecord::Migration
  def self.up
    create_table :class_subjects do |t|
       t.integer :group_id
       t.integer :subject_id
       t.integer :handled_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :class_subjects
  end
end
