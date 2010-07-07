class AddParentUserIdToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :parent_user_id, :integer
  end

  def self.down
  end
end
