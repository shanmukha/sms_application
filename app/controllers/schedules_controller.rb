class SchedulesController < ApplicationController
 layout "main"

	def index
  	@search =  Schedule.search(params[:search])
    @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('admin')
    @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('admin')
    @search.order ||= "descend_by_created_at"
    @schedules = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end
 
 def show
    @schedule = Schedule.find(params[:id])
    @students = @schedule.students.find(:all)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end
  
   def status_update
        @schedule = Schedule.find(params[:id])
       	schedules = @schedule.schedule_students
        admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
        school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
       	MessageSchedule.user = school.server_user_name
        MessageSchedule.password = school.server_password
       	unless schedules.blank?
       	  schedules.each do |schedule|
          	sms = MessageSchedule.find(schedule.sms_id)
          	sms.save   #calling update method of the API
          	schedule.update_attribute('status', sms.status)
      	 end 
      else
      	sms = MessageSchedule.find(@schedule.sms_id)
        sms.save   #calling update method of the API
        @schedule.update_attribute('status', sms.status)
      end  
      respond_to do |format|
        format.html { redirect_to(schedule_url(@schedule))} 
        format.xml  { render :xml => @schedule }
      end
      rescue #ActiveResource::ResourceInvalid => e  
      	flash[:error] = 'Some thing went wrong. Please try again latter.'    
      	redirect_to(schedules_url) 
   end
  
    def destroy
     @schedule = Schedule.find(params[:id])
     schedules = @schedule.schedule_students
     admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
     school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
     MessageSchedule.user = school.server_user_name
     MessageSchedule.password = school.server_password
     unless schedules.blank?
       schedules.each do |schedule|
       res = MessageSchedule.delete(schedule.sms_id)   #calling destroy method of the API.
       schedule.update_attribute('status', 'Cancelled') if res.code == '200'
      end 
     else 
       res = MessageSchedule.delete(@schedule.sms_id)   #calling destroy method of the API.
       @schedule.update_attribute('status', 'Cancelled') if res.code == '200'
     end  
      respond_to do |format|
        format.html { redirect_to(schedule_url(@schedule))} 
        format.xml  { render :xml => @schedule }
      end
        rescue #ActiveResource::ResourceInvalid => e  
      	flash[:error] = 'Some thing went wrong. Please try again latter.'    
      	redirect_to(schedules_url) 
    end
 
  private
     def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
  end  



