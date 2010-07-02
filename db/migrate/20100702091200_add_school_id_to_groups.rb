class AddSchoolIdToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :school_id, :integer
  end

  def self.down
  end
end
