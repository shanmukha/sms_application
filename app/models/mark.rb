class Mark < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  belongs_to :subject
  validates_presence_of :exam_id,:subject_id,:student_id

end
