class School < ActiveRecord::Base
   has_many :groups
   has_many :exams
   has_many :academic_years
   belongs_to :administrator, :class_name => 'User'
   accepts_nested_attributes_for :administrator
   
   #has_many :students, :include => {:groups => 'school' },:conditions =>['schools.id = ?', self.id]
end
