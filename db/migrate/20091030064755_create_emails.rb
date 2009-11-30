class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.text :body
      t.string :subject
      t.integer :group_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
