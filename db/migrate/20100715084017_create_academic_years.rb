class CreateAcademicYears < ActiveRecord::Migration
  def self.up
    create_table :academic_years do |t|
      t.date :from_date
      t.date :to_date
      t.string :identification_name
      t.boolean :current
      t.integer :school_id

      t.timestamps
    end
  end

  def self.down
    drop_table :academic_years
  end
end
