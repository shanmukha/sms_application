class UserSessionsController < ApplicationController
   layout "login"
    skip_before_filter :check_logged_in 
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      if current_user.has_role?("super_admin")
        redirect_to admin_schools_url
      elsif current_user.has_role?("admin")
        redirect_to root_url
      elsif current_user.has_role?("parent")
        student = Student.find(:first,:conditions=>['parent_user_id=?',current_user.id])
        redirect_to student_details_students_url(:student_id=>student.id)
      end
    else
      flash.now[:error] = "Invalid username and/or password. Please try again"
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to new_user_session_path
   end
end
