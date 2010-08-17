class AddFieldToSubjects < ActiveRecord::Migration
  def self.up
  add_column :subjects, :school_id, :integer
    remove_column :subjects,:user_id
  end

  def self.down
  end
end
