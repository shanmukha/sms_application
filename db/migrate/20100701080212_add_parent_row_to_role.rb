class AddParentRowToRole < ActiveRecord::Migration
  def self.up
    Role.create(:name=>'parent')
  end

  def self.down
   Role.delete
  end
end
