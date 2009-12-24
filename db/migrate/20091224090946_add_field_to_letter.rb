class AddFieldToLetter < ActiveRecord::Migration
  def self.up
     add_column :letters, :reference, :string
  end

  def self.down
  end
end
