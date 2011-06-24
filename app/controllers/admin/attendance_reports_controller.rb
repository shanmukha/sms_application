class Admin::AttendanceReportsController < ApplicationController
  layout "admin"
 before_filter :check_admin_role
  def index 
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
    school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
    academic_year = AcademicYear.current_academic_year_school(school.id)

   unless params[:report].nil?
     if !params[:report][:group_id].nil? and !params[:report][:subject_id].nil?
       @subject = Subject.find(params[:report][:subject_id])
       @class = Group.find(params[:report][:group_id])
       year=params[:report]['date(1i)']
       month=params[:report]['date(2i)']
       day=params[:report]['date(3i)']
       @date = Time.parse("#{year}-#{month}-#{day}").strftime("%y-%m-%d")
      
      if params[:report]["date(1i)"].blank? and params[:report]["date(2i)"].blank? and params[:report]["date(3i)"].blank?
         @students = @class.students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active'])
        total_attendance = ClassSubjectAttendance.count(:all,:conditions =>['subject_id = ? and group_id = ? and academic_year_id = ?',@subject.id,@class.id,academic_year.id])
        @percentage = []
        @students.each do |student|
          student_attendance = StudentAttendance.count(:all,:include =>[:class_subject_attendance],:conditions =>['student_id=? and class_subject_attendances.subject_id =? and class_subject_attendances.group_id =? and class_subject_attendances.academic_year_id =?',student.id,@subject.id,@class.id,academic_year.id])
       @percentage<< (student_attendance/total_attendance.to_f*100.0).round(1)    
        end
    else
      @present_students = StudentAttendance.find(:all,:joins =>[:class_subject_attendance],:conditions =>['class_subject_attendances.subject_id =? and class_subject_attendances.group_id  =? and  class_subject_attendances.date like ? and class_subject_attendances.academic_year_id =?',@subject.id,@class.id,'%'+@date+'%',academic_year.id])

      @absent_students = @class.students.find(:all,:include =>[:student_classes],:conditions =>['students.id not in(?) and student_classes.academic_year_id =? and status =?',@present_students.map{|a|a.student_id},academic_year.id,'Active'])

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
