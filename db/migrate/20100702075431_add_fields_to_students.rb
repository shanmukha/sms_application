class AddFieldsToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :student_mobile_number, :string
    add_column :students, :student_email, :string

  end

  def self.down
  end
end
