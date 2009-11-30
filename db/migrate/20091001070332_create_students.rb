class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :name
      t.string :parent
      t.string :number
      t.text :address
      t.string :email
      t.string :roll_number
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
