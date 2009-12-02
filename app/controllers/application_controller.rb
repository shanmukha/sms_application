

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery
  filter_parameter_logging :password
  helper_method :current_user
  before_filter :check_logged_in 
  private
  
  def check_logged_in
    if current_user!=nil 
      return 
    else  
    flash[:notice]= "Please login."
    redirect_to '/login'
     end  
   end

  def check_role(super_admin_role,admin_role)
  	  unless ((current_user.has_role?(super_admin_role)) ||(current_user.has_role?(admin_role)) )
       flash[:notice]= "Permission denied."
       redirect_to root_path
     end  
  end

  def check_admin_role
     unless current_user.has_role?('admin')
        flash[:notice]= "Permission denied."
       redirect_to root_path
     end  
   end  
  	
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
end
