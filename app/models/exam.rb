class Exam < ActiveRecord::Base
 belongs_to :group
 validates_presence_of :group_id,:subject_id,:maximum_marks,:exam_type
end

