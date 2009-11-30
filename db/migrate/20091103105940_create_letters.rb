class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.text :content
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
  end

  def self.down
    drop_table :letters
  end
end
