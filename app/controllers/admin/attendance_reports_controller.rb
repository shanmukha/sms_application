class Admin::AttendanceReportsController < ApplicationController
  layout "admin"
 before_filter :check_admin_role
  def index
   unless params[:report].nil?
   if !params[:report][:group_id].nil? and !params[:report][:subject_id].nil?
   @subject = Subject.find(params[:report][:subject_id])
   @class = Group.find(params[:report][:group_id])
    @students = @class.students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active'])
     total_attendance = ClassSubjectAttendance.count(:all,:conditions =>['subject_id =?',@subject.id])
     @percentage = []
     @students.each do |student|
       student_attendance = StudentAttendance.count(:all,:joins =>[:class_subject_attendance],:conditions =>['student_id=? and class_subject_attendances.subject_id =?',student.id,@subject.id])
       @percentage<< student_attendance/total_attendance.to_f*100

      end
   end
  end
end
  
  def render_subjects
    str=''
   Group.find(params[:group_id]).subjects.find(:all).each do |subject|
    str += "<option value=#{subject.id}>#{subject.name}</option>"
end
render :update do |page|

       page << "jQuery('#report_subject_id').html('#{str}');"
      end 
    end
end
