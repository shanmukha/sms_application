class CreateStudentClasses < ActiveRecord::Migration
  def self.up
    create_table :student_classes do |t|
      t.integer :academic_year_id
      t.integer :student_id
      t.integer :roll_number
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :student_classes
  end
end
