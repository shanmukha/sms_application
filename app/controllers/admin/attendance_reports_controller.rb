class Admin::AttendanceReportsController < ApplicationController
  layout "admin"
 before_filter :check_admin_role
  def index
   unless params[:report].nil?
     if !params[:report][:group_id].nil? and !params[:report][:subject_id].nil?
       @subject = Subject.find(params[:report][:subject_id])
       @class = Group.find(params[:report][:group_id])
       year=params[:report]['date(1i)']
       month=params[:report]['date(2i)']
       day=params[:report]['date(3i)']
       if month=='1' or month=='2'or month=='3'or month=='5'or month=='6' or month=='7'or month=='8'or month=='9'
         @date = year+ '-'+ '0'+ month + '-' +day
       else
        @date = year+ '-'+ month + '-' +day
      end 
       if params[:report]["date(1i)"].blank? and params[:report]["date(2i)"].blank? and params[:report]["date(3i)"].blank?
         @students = @class.students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active'])
        total_attendance = ClassSubjectAttendance.count(:all,:conditions =>['subject_id =? and group_id=?',@subject.id,@class.id])
        @percentage = []
        @students.each do |student|
          student_attendance = StudentAttendance.count(:all,:joins =>[:class_subject_attendance],:conditions =>['student_id=? and class_subject_attendances.subject_id =? and class_subject_attendances.group_id =?',student.id,@subject.id,@class.id])
       @percentage<< student_attendance/total_attendance.to_f*100
      end
    else
      @students_attendance = StudentAttendance.find(:all,:joins =>[:class_subject_attendance],:conditions =>['class_subject_attendances.subject_id =? and class_subject_attendances.group_id  =? and  class_subject_attendances.date like ?',@subject.id,@class.id,'%'+@date+'%'])

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
