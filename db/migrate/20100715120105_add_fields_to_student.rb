class AddFieldsToStudent < ActiveRecord::Migration
  def self.up
   add_column :students, :dob, :date
   add_column :students, :gender,:string
   add_column :students,  :language,:string
   add_column :students,  :mother,:string 
   add_column :students,  :mother_mobile,:string
   add_column :students,  :father,:string
   add_column :students,  :father_mobile,:string
   add_column :students,  :guardian,:string
   add_column :students,  :guardian_number,:string
   add_column :students,  :date_of_admission,:date
   add_column :students,  :date_of_passing,:date
   add_column :students,  :blood_group,:string
  end

  def self.down
  end
end


