class ScheduleReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 def teacher_schedules
     @teachers = User.find_teachers(current_user)
     @teachers_name,@teachers_schedule_size = User.find_teachers_name_schedule_size(current_user,@teachers)
  end
  
  def tag_schedules
     @tags = current_user.tags
     @tags_name,@tags_schedule_size = Tag.find_tags_name_schedule_size(current_user,@tags)
  end
  
  def class_schedules
      @classes = current_user.groups 
      @classes_name,@classes_schedule_size = Group.find_classes_name_schedule_size(current_user,@classes)
  end
  
  def student_schedules
     @students = current_user.students
     @students_name,@students_schedule_size = Student.find_students_name_schedule_size(current_user,@students)
  end 
  
  def month_schedules
      @from_date = params[:report][:from_date].to_date unless params[:report].nil?
  	  @to_date =  params[:report][:to_date].to_date unless params[:report].nil?
  	  @schedule_months,@reports = Schedule.find_month_wise_report(@from_date,@to_date,current_user) unless params[:report].nil?
  	   @months = @schedule_months.each_key {|key| key} unless @schedule_months.nil?
  end  
  
   def show
     @schedule = Schedule.find(params[:id])
     @students = @schedule.students.find(:all)
  end
end
