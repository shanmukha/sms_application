class AttendancesController < ApplicationController
  layout "main"
 def new
  @class_subject_attendance = ClassSubjectAttendance.new
 end
 def create
  for subject in params[:subjects] 
    class_subject_attendance = ClassSubjectAttendance.new(params[:class_subject_attendance])
    class_subject_attendance.subject_id = subject
    #class_subject_attendance.student_ids = params[:students]
    class_subject_attendance.save
    for student in params[:students]
      student_attendance = StudentAttendance.new
      student_attendance.student_id = student
      student_attendance.class_subject_attendance_id = class_subject_attendance.id
      student_attendance.present = true
      student_attendance.save
    end      
   end
  redirect_to new_attendance_path
 end

 def group_subject_students
  @students = Group.find(params[:group_id]).students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active']) rescue ''
   @subjects = Group.find(params[:group_id]).subjects.find(:all) rescue ''  
   render :update do |page|
     page.replace_html 'subject_students', :partial => 'group_subjects_students'
    end
 end
 end
