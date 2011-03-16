class Subject < ActiveRecord::Base
 belongs_to :school
 has_many :exam_subjects
 has_many :exams,:through => :exam_subjects
 has_many :student_subjects
 has_many :students,:through => :student_subjects
 has_many :marks
 has_many :class_subjects
 has_many :groups,:through => :class_subjects
 has_many :class_subject_attendances
 validates_presence_of :name

end
