class AddSchoolIdToUsers < ActiveRecord::Migration
  def self.up
     add_column :users, :school_id, :integer
  end

  def self.down
  end
end
