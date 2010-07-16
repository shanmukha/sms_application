class CreateExamClasses < ActiveRecord::Migration
  def self.up
    create_table :exam_classes do |t|
      t.integer :exam_id
      t.integer :group_id
      t.integer :academic_year_id

      t.timestamps
    end
  end

  def self.down
    drop_table :exam_classes
  end
end
