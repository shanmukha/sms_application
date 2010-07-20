class Exam < ActiveRecord::Base
 belongs_to :group
 belongs_to :school
 has_many :marks
 has_many :exam_classes
 has_many :exam_subjects
 has_many :groups, :through => :exam_classes
 #has_many :subjects, :through => :exam_subjects, :class_name => 'Subject'
 validates_presence_of :exam_type
 
end

