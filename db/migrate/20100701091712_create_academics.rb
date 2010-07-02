class CreateAcademics < ActiveRecord::Migration
  def self.up
    create_table :academics do |t|
      t.string :year
      t.date :start_date 
      t.date :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :academics
  end
end
