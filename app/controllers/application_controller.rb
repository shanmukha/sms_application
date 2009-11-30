

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

  def check_role(role)
  	list ||= current_user.roles.collect(&:name)
    role = list.include?(role)
    if role==true
      return
    else
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
