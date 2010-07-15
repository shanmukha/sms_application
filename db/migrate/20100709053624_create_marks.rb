class CreateMarks < ActiveRecord::Migration
  def self.up
    create_table :marks do |t|
      t.integer :exam_id
      t.integer :student_id
      t.integer :subject_id
      t.integer :mark

      t.timestamps
    end
  end

  def self.down
    drop_table :marks
  end
end
