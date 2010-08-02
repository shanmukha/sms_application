class AddGroupIdToMarks < ActiveRecord::Migration
  def self.up
   add_column :marks, :group_id, :integer
  end

  def self.down
  end
end
