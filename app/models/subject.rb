class Subject < ActiveRecord::Base
 belongs_to :user
 belongs_to :school
 belongs_to :group
 has_many :exam_subjects
 has_many :exams,:through => :exam_subjects
 has_many :marks
 has_many :class_subjects
 has_many :groups,:through => :class_subjects
 validates_presence_of :name
# validates_presence_of :group_id , :message => 'Please select a class'
end
