class AddFieldToStudent < ActiveRecord::Migration
  def self.up
   add_column :students, :status, :string,:default =>"Active"
  end

  def self.down
  end
end
