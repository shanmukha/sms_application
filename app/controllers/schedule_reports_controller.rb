class ScheduleReportsController < ApplicationController
 layout "admin"
 before_filter :check_admin_role
 def teacher_schedules
     @teachers = User.find_teachers(current_user)
  end
  
  def tag_schedules
     @tags = current_user.tags
  end
  
  def class_schedules
      @classes = current_user.groups 
  end
  
  def student_schedules
     @students = current_user.students
  end 
  
   def show
     @schedule = Schedule.find(params[:id])
     @students = @schedule.students.find(:all)
  end
end
