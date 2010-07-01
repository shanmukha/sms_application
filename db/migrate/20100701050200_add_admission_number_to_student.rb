class AddAdmissionNumberToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :adminssion_number, :string
  end

  def self.down
  end
end
