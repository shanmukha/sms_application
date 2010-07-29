class AddFieldToSubject < ActiveRecord::Migration
  def self.up
   add_column :subjects, :use_grade, :boolean
   add_column :subjects, :description,:text
  end

  def self.down
  end
end
