class CreateParents < ActiveRecord::Migration
  def self.up
    create_table :parents do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :parents
  end
end
