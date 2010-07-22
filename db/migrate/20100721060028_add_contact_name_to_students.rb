class AddContactNameToStudents < ActiveRecord::Migration
  def self.up
   add_column :students, :contact_name, :string
   remove_column :students, :parent
  end

  def self.down
  end
end
