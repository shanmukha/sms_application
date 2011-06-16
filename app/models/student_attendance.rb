class StudentAttendance < ActiveRecord::Base
 belongs_to :student
 belongs_to :class_subject_attendance


  def self.find_attendance(academic_year,group,student)
    subjects = group.subjects.find(:all)
    percentage = {}
    subjects.each do |subject|
      total_attendance = ClassSubjectAttendance.count(:all,:conditions =>['subject_id = ? and group_id = ? and academic_year_id = ?',subject.id,group.id,academic_year.id])
     subject_attendance = StudentAttendance.count(:all,:joins =>[:class_subject_attendance],:conditions =>['student_id=? and class_subject_attendances.subject_id =? and class_subject_attendances.group_id =? and class_subject_attendances.academic_year_id =?',student.id,subject.id,group.id,academic_year.id])
      percentage[subject.id] = "#{(subject_attendance/total_attendance.to_f*100).round(1)}" + '%' rescue '0' + '%'
   end
   return subjects,percentage
  end
end
