class MessagesController < ApplicationController
 layout proc{ |c| ['new', 'create'].include?(c.action_name)? 'message' : 'main'}

  def new
    @message = Message.new
  end

  def index
     @search =  Message.search(params[:search]) 
     @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('super_admin')
     @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
     @search.order ||= "descend_by_created_at"
     @messages = @search.all.paginate :page => params[:page],:per_page => 25
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end
	
  def show
    @message =  Message.find(params[:id])
    @students = @message.students.find(:all)
    respond_to do |format|
      format.html # show.html.erb
        format.js  { render :layout => false}
    end
  end
	
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.html { redirect_to(message_s_url) }
      format.xml  { head :ok }
    end
  end
 
  def create
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
    
     if params[:students].blank? and params[:message][:number].blank?
      flash.now[:error] = "Please select at least one student or enter mobile number."
      render :action => "new"
      return nil
    end
      
    if params[:message][:message_body].blank?
      flash.now[:error] = "Please enter message content."
      render :action => "new"
      return nil
    end
    
    no_of_sms = params[:students].nil? ? find_message_size(params[:message][:message_body]) : 	find_students_message_size(params[:message][:message_body],params[:students])
    
    
     if admin.client_type == "Limited"
       balance = admin.balance.to_i - no_of_sms
       if balance <= 0
         flash[:notice] = "Please ensure you have suffecient balance in your account."   
         redirect_to(new_message_url) 
        return nil
      end 
   
    elsif admin.client_type == "Unlimited"
       if admin.end_date.strftime('%Y-%m-%d') <  Time.now.strftime('%Y-%m-%d')
          flash[:notice] = "Please ensure your account validity expired or not."   
          redirect_to(new_message_url) 
         return nil 
    end
   end   
   
    #set active resource API authentication credentials dynamically
    MessageService.user = admin.server_user_name
    MessageService.password = admin.server_password
    MessageSchedule.user = admin.server_user_name
    MessageSchedule.password = admin.server_password
    
    #check wheather message is sending on schedule 
    if params[:message][:scheduled_date].blank?  
      @message = current_user.messages.new(params[:message]) 
    else  
      time_p = params[:schedule]
      params[:message][:scheduled_time] = Time.parse("#{time_p['time(4i)']}:#{time_p['time(5i)']}")
      @message = current_user.schedules.new(params[:message])
    end
    
     begin
      if @message.save
         if !params[:students].nil?
	          message = @message.message_body
            params[:students].each do  |student_id|
               student_record = Student.find(student_id)
               student, parent = student_record.name, student_record.parent
               message.gsub!(/@student/, student) 
       	       message.gsub!(/@parent/, parent)
       	       message.gsub!(/@Student/, student) 
       	       message.gsub!(/@Parent/, parent)
       	       if  params[:message][:scheduled_date].blank?
       	         sms = MessageService.create(:sms => params[:message].merge!({:number => student_record.number})) 
       	         message_student = MessageStudent.create(:message_id => @message.id, :student_id => student_id, :sms_id => sms.id)
               elsif  !params[:message][:scheduled_date].blank?
                 sms = MessageSchedule.create(:sms => params[:message].merge!({:number => student_record.number}))  
                 schedule_student = ScheduleStudent.create(:schedule_id => @message.id, :student_id => student_id, :sms_id => sms.id)
               end
              
               message.gsub!(/#{student}/,'@student') 
               message.gsub!(/#{parent}/,'@parent') 
             
       	     end 
             
	  else
	         if params[:message][:scheduled_date].blank? 
       	      sms = MessageService.create(:sms => params[:message]) 
       	      @message.update_attributes({:status => "Sent", :sms_id => sms.id}) 
       	       
       	    elsif !params[:message][:scheduled_date].blank?
       	      sms = MessageSchedule.create(:sms => params[:message])
       	      @message.update_attributes({:status => "Scheduled", :sms_id => sms.id}) 
       	     
            end	   
           
	     end
	         admin.update_attribute('balance', balance) if admin.client_type == "Limited" 
	         flash[:notice] = 'Message is sent for delivery. Please check the status after some time.'
           redirect_to(new_message_url)
         else  #@message.save check
           render :action => "new"
         end 
       end
         rescue #ActiveResource::ResourceInvalid => e  
         flash[:error] = 'There seems to be some problem upadting the delevery status. Please try again latter.'    
         redirect_to(messages_url) 
     end
  
    def status_update
       @message = Message.find(params[:id])
       messages = @message.message_students
       admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
       MessageService.user = admin.server_user_name
       MessageService.password = admin.server_password
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
        flash[:notice] = 'Status is successfully updated.'
        format.html { redirect_to(message_url(@message))} 
        format.xml  { render :xml => @message }
      end
      rescue #ActiveResource::ResourceInvalid => e  
         flash[:error] = 'There seems to be some problem upadting the delevery status. Please try again latter.'    
         redirect_to(messages_url) 
    end
  
	
  def render_message_template
    @message_content = MessageTemplate.find(params[:message_message_id]).message_body rescue ''
    @tag_id = MessageTemplate.find(params[:message_message_id]).tag_id rescue ''
   
    render :update do |page|
       page << "jQuery('#message_message_body').val('#{escape_javascript(@message_content)}')"
       page << "jQuery('#message_tag_id').val('#{@tag_id}')"
    end
  end
  
  def student_groups
      @students = Group.find(params[:group_id]).students.find(:all, :order => 'students.name ASC') rescue ''
      render :update do |page|
     	page.replace_html 'students', :partial => 'group_student'if !@students.blank?
      page.replace_html 'students', :partial => 'mobile_number' if @students.blank?
   end
  end 
  
  def student_message_resend
      admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
      MessageService.user = admin.server_user_name
      MessageService.password = admin.server_password
      @message = Message.find(params[:message_id])
      student_record = Student.find(params[:student_id])
      message = @message.message_body
      params[:message] = {}
      params[:message][:message_body] = message
      params[:message][:number] =  student_record.number
      student, parent = student_record.name, student_record.parent
      message.gsub!(/@student/, student) 
      message.gsub!(/@parent/, parent)
      message.gsub!(/@Student/, student) 
      message.gsub!(/@Parent/, parent)
      sms = MessageService.create(:sms => params[:message]) 
      message_student = MessageStudent.find_by_student_id_and_message_id(student_record.id,@message.id)
      message_student.update_attributes(:message_id => @message.id, :student_id => student_record.id, :sms_id => sms.id,:status => "Sent")
       flash[:notice] = 'Message is sent for delivery. Please check the status after some time.'   
       redirect_to message_path(@message) 
       rescue #ActiveResource::ResourceInvalid => e  
    	 		flash.now[:error] = 'There seems to be a problem in sending message. Please try again latter.'  
    	  	redirect_to message_path(@message)  
     end

 private
  
  def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
  
  def find_message_size(message_body)
       message_size = 1
       message_body_size = message_body.size 
       while( message_body_size >160)
        	message_body_size = message_body_size -160 
             message_size += 1 
       end 
        return message_size
  end     
 
 	def find_students_message_size(message_body,students)
      total_message_size = 0
      students.each do  |student_id|
      	student_record = Student.find(student_id)
        student, parent = student_record.name, student_record.parent
        message_body.gsub!(/@student/, student) 
       	message_body.gsub!(/@parent/, parent)
        message_size = find_message_size(message_body)
        total_message_size += message_size
        message_body.gsub!(/#{student}/,'@student') 
        message_body.gsub!(/#{parent}/,'@parent') 
     end
       return total_message_size
   end 
 end  
