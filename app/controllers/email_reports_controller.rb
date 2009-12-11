class EmailReportsController < ApplicationController
 layout "admin"
 before_filter :check_admin_role
 
 def teacher_emails
     @teachers = User.find_teachers(current_user)
  end

  def class_emails
      @classes = current_user.groups 
  end
   
   def student_emails
       @students = current_user.students  
   end
   
   def show
     @email = Schedule.find(params[:id])
     @students = @email.students.find(:all)
  end
   
end
