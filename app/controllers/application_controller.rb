

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
    redirect_to '/login'
     end  
   end

  def check_role(super_admin_role,admin_role)
  	  unless ((current_user.has_role?(super_admin_role)) ||(current_user.has_role?(admin_role)) )
       flash[:notice]= "Permission denied."
       redirect_to root_path
     end  
  end

  def find_months_name_communication_size(months,reports)
        month_name= ["nil","January"," February"," March"," April"," May"," June"," July"," August"," September"," October"," November"," December"]
        @months_name = []
        @communication_size  = Array.new(months.size){Array.new(1)}
        i = 0
        months.each do|month|
          key = month.strftime("%m").to_i
          @months_name << month_name[key]
          @communication_size[i][0] = reports[month]
          i = i+ 1 
       end  
      return @months_name,@communication_size  
  end
 
  def check_admin_role
     unless current_user.has_role?('admin')
        flash[:notice]= "Permission denied."
       redirect_to root_path
     end  
   end  

  def check_teacher_role
     unless current_user.has_role?('teacher')
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
