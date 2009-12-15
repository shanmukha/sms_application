class LetterReportsController < ApplicationController
   require 'gchart'
  layout "admin"
  before_filter :check_admin_role
 def teacher_letters
      @teachers = User.find_teachers(current_user)
      @teachers_name,@teachers_letter_size = User.find_teachers_name_letter_size(current_user,@teachers)
  end
  
  def class_letters
      @classes = current_user.groups 
      @classes_name,@classes_letter_size = Group.find_classes_name_letter_size(current_user,@classes)
  end
     
  def student_letters
      @students = current_user.students
      @students_name,@students_letter_size = Student.find_students_name_letter_size(current_user,@students)
  end  
  
  def show
     @letter = Letter.find(params[:id])
     @students = @letter.students.find(:all)
  end
  
  def print
    @letter = Letter.find(params[:id])
    @students = @letter.students.find(:all)
    respond_to do |format|
    format.pdf  {
       options = { :left_margin => 30, :right_margin => 30, :top_margin => 10, :bottom_margin => 5}
       prawnto :inline => true, :prawn => options, :filename => 'school.pdf'
       render :layout => false}
      end
  end  
  
     
end
