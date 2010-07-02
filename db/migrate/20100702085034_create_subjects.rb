class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string :name
      t.string :short_code
      t.integer :max_marks
      t.integer :passing_marks
      t.integer :group_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end
end
