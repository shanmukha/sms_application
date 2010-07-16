class Exam < ActiveRecord::Base
 belongs_to :group
 belongs_to :school
 has_many :marks
 has_many :exam_classes
 has_many :groups,:through => :exam_classes
 validates_presence_of :group_id,:subject_id,:maximum_marks,:exam_type
end

