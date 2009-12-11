class LetterReportsController < ApplicationController
  layout "admin"
  before_filter :check_admin_role
 def teacher_letters
      @teachers = User.find_teachers(current_user)
  end
  
  def class_letters
      @classes = current_user.groups 
  end
     
  def student_letters
      @students = current_user.students
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
