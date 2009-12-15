class MessageReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
	def teacher_messages
	  @teachers = User.find_teachers(current_user)
	  @teachers_name,@teachers_message_size = User.find_teachers_name_message_size(current_user,@teachers)
 end  
 
 def tag_messages
   @tags = current_user.tags
   @tags_name,@tags_message_size = Tag.find_tags_name_message_size(current_user,@tags)
  end
  
  def class_messages
   @classes = current_user.groups 
   @classes_name,@classes_message_size = Group.find_classes_name_message_size(current_user,@classes)
  end
  
  def student_messages
    @students = current_user.students
    @students_name,@students_message_size = Student.find_students_name_message_size(current_user,@students)
  end
  
  def month_messages
  	@from_date = params[:report][:from_date]
  	@to_date =  params[:report][:to_date]
  	@messages = Message.find_month_wise_report(@from_date,@to_date,current_user)
  end
  
  def show
     @message = Message.find(params[:id])
     @students = @message.students.find(:all)
  end
end 

