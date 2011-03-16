class ClassSubjectAttendance < ActiveRecord::Base
 belongs_to :group
 belongs_to :subject
 has_many :student_attendances
 has_many :students ,:through => :student_attendances
end
