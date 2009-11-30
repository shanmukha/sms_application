class CreateMessageTemplates < ActiveRecord::Migration
  def self.up
    create_table :message_templates do |t|
      t.text :message_body
      t.string :message_title
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :message_templates
  end
end
