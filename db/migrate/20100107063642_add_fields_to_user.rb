class AddFieldsToUser < ActiveRecord::Migration
   def self.up
     add_column :users, :client_type, :string
     add_column :users, :end_date, :date
  end
  def self.down
  
  end
end
