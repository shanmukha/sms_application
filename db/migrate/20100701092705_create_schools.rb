class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.integer :administrator_id
      t.string :school_name
      t.string :server_user_name
      t.string :server_password
      t.string :plan_type
      t.string :sms_limit
      t.string :credits 
      t.date :end_date
      t.string :school_email
      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
