class MessageServicesController < ApplicationController
 before_filter :set_thread_user
  layout proc{ |c| ['new'].include?(c.action_name)? 'message' : 'main'}
	def new
   @message = Message.new
   @groups = current_user.groups.find(:all,:conditions =>['status =?','Active'])
  end

	def index
     @search =  Message.search(params[:search]) 
     @search.user_id = current_user.id
     @search.order ||= "descend_by_created_at"
     @messages = @search.all.paginate :page => params[:page],:per_page => 25
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end
	

	def show
    @message = current_user.messages.find(params[:id])
    @students = @message.students.find(:all)
    respond_to do |format|
      format.html # show.html.erb
        format.js  { render :layout => false}
    end
  end
	
	def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to(message_services_url) }
      format.xml  { head :ok }
    end
  end
 
 def create
	 begin
	   no_of_sms = params[:students].nil? ? 1 : params[:students].size
	   balance = current_user.balance.to_i - no_of_sms
	   MessageService.user = current_user.server_user_name
     MessageService.password = current_user.server_password
     MessageSchedule.user = current_user.server_user_name
     MessageSchedule.password = current_user.server_password
	   if balance >= 0
	     if params[:sms][:scheduled_date].blank?  
	        @message = current_user.messages.new(params[:sms]) 
	     else  
	        #sending on schedule 
	        params[:sms][:scheduled_time] =  Time.parse(params[:schedule][:"scheduled_time(5i)"])
          @message = current_user.schedules.new(params[:sms])
       end
	     
	     if @message.save
	       if !params[:students].nil?
	         message = @message.message_body
           params[:students].each do  |student_id|
             student_record = Student.find(student_id)
             student, parent = student_record.name, student_record.parent
             message.gsub!(/@student/, student) 
       	     message.gsub!(/@parent/, parent)
       	     if  params[:sms][:scheduled_date].blank?
       	       sms = MessageService.create(:sms => params[:sms].merge!({:number => student_record.number})) 
               message_student = MessageStudent.create(:message_id => @message.id,:student_id => student_id,:sms_id => sms.id)
             elsif  !params[:sms][:scheduled_date].blank?
               sms = MessageSchedule.create(:sms => params[:sms].merge!({:number => student_record.number}))  
               schedule_student = ScheduleStudent.create(:schedule_id => @message.id,:student_id => student_id,:sms_id => sms.id)
             end
             current_user.update_attribute('balance', current_user.balance.to_i - 1)
             message.gsub!(/#{student}/,'@student') 
        	   message.gsub!(/#{parent}/,'@parent') 
        	 end  
	       else
	          if  params[:sms][:scheduled_date].blank? 
       	  	  sms = MessageService.create(:sms => params[:sms]) 
       	      @message.update_attributes({:status => "Sent", :sms_id => sms.id}) 
       	    elsif  !params[:sms][:scheduled_date].blank?
       	   	   sms = MessageSchedule.create(:sms => params[:sms])
       	       @message.update_attributes({:status => "Scheduled", :sms_id => sms.id}) 
            end	   
             current_user.update_attribute('balance', current_user.balance.to_i - 1)   
	       end
	       
	       flash[:notice] = 'The Message is pushed to the network. We will update the delivery status'   
         redirect_to(new_message_service_url)
	     else  #@message.save check
         render :action => "new"
       end 
	   else #no sufficient balance
	     flash[:notice] = "Please ensure you have suffecient balance in your account."   
       redirect_to(new_message_service_url) 
	   end
	   rescue #ActiveResource::ResourceInvalid => e  
       flash[:error] = 'Some thing went wrong. Please try again latter.'    
       redirect_to(new_message_service_url) 
     end
  end
  
	def status_update
  	@message = Message.find(params[:id])
  	messages = @message.message_students
    MessageService.user = current_user.server_user_name
    MessageService.password = current_user.server_password
    unless messages.blank?
      messages.each do |msg|
      	sms = MessageService.find(msg.sms_id)
     	  sms.save   #calling update method of the API
        msg.update_attribute('status', sms.status) 
     	end
    else
      sms = MessageService.find(@message.sms_id)
      sms.save   #calling update method of the API
      @message.update_attribute('status', sms.status) 
      end  
      respond_to do |format|
        flash[:notice] = 'Status successfully updated.'
        format.html { redirect_to(message_service_url(@message))} 
        format.xml  { render :xml => @message }
      end
       rescue #ActiveResource::ResourceInvalid => e  
         flash[:error] = 'Some thing went wrong. Please try again latter.'    
         redirect_to(message_services_url) 
    end
  
	
	def show
     @message = current_user.messages.find(params[:id])
     @students = @message.students.find(:all)
     respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end
	
	def render_message_template
    @message_template = MessageTemplate.find(params[:sms_id]).message_body rescue ''
    render :update do |page|
       page << "jQuery('#sms_message_body').val('#{@message_template}')"
      end
  end
  
  def student_groups
      @students = Group.find(params[:group_id]).students rescue ''
      render :update do |page|
     	page.replace_html 'students', :partial => 'group_student'
   end
  end 
  

  private
    def set_thread_user
      Thread.current["user"] = current_user
   end
  end
  
