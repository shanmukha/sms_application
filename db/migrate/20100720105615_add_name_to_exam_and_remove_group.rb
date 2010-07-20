class AddNameToExamAndRemoveGroup < ActiveRecord::Migration
  def self.up
    add_column :exams, :name, :string
    remove_column :exams, :group_id
  end

  def self.down
  end
end
