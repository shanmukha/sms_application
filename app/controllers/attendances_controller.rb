class AttendancesController < ApplicationController
  layout "main"
 
 def index
   unless params[:date].blank? and params[:subject_id].blank? and params[:group_id].blank?
    @date = params[:date]
    @subject = Subject.find(params[:subject_id])
    @class = Group.find(params[:group_id])
    @present_students = StudentAttendance.find(:all,:joins =>[:class_subject_attendance],:conditions =>['class_subject_attendances.subject_id =? and class_subject_attendances.group_id  =? and  class_subject_attendances.date like ?',params[:subject_id],params[:group_id],'%'+ Time.parse(params[:date]).strftime("%Y-%m-%d")+ '%'])
    @absent_students = @class.students.find(:all,:conditions =>['students.id not in(?)',@present_students.map{|a|a.student_id}])
  end
 end  

 def new
  @class_subject_attendance = ClassSubjectAttendance.new
 end
 def create
   school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
    academic_year = AcademicYear.current_academic_year_school(school.id)
  for subject in params[:subjects] 
    class_subject_attendance = ClassSubjectAttendance.new(params[:class_subject_attendance])
    class_subject_attendance.subject_id = subject
     class_subject_attendance.academic_year_id = academic_year.id
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
def render_subjects
    str=''
   Group.find(params[:group_id]).subjects.find(:all).each do |subject|
    str += "<option value=#{subject.id}>#{subject.name}</option>"
end
render :update do |page|

       page << "jQuery('#subject_id').html('#{str}');"
      end 
    end


 end
