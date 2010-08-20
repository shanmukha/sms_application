class Exam < ActiveRecord::Base
# belongs_to :group
 belongs_to :school
 has_many :marks
 has_many :exam_classes
 has_many :exam_subjects
 has_many :groups, :through => :exam_classes
 has_many :subjects, :through => :exam_subjects
 validates_presence_of :exam_type
  
 def self.find_exam_names_and_percentage(academic_year,school)
    percentages =[]
    exam_names =[] 
    Exam.find(:all,:include=>[:exam_classes],:conditions => ['exam_classes.academic_year_id =? and school_id =?',academic_year.id,school.id]).map{|object|exam_names << object.name} 
   return exam_names 
end
end

