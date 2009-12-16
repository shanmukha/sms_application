class EmailReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
  def teacher_emails
      @teachers = User.find_teachers(current_user)
      @teachers_name,@teachers_email_size = User.find_teachers_name_email_size(current_user,@teachers)
  end

  def class_emails
      @classes = current_user.groups 
      @classes_name,@classes_email_size = Group.find_classes_name_email_size(current_user,@classes)
  end
   
   def student_emails
       @students = current_user.students  
       @students_name,@students_email_size = Student.find_students_name_email_size(current_user,@students)
   end
   
    def month_emails
      @from_date = params[:report][:from_date].to_date unless params[:report].nil?
  	  @to_date =  params[:report][:to_date].to_date unless params[:report].nil?
  	  @email_months,@reports = Email.find_month_wise_report(@from_date,@to_date,current_user) unless params[:report].nil?
  	   @months = @email_months.each_key {|key| key} unless @email_months.nil?
  	   rescue 
    	  flash[:error] = 'Please check from date and to date selected or not.'    
    end 
   
   def show
     @email = Schedule.find(params[:id])
     @students = @email.students.find(:all)
  end
   
end
