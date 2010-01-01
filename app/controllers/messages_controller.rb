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

    no_of_sms = params[:students].nil? ? 1 : params[:students].size
    
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

    #balance = admin.balance.to_i - no_of_sms
    #if balance <= 0
      #flash[:notice] = "Please ensure you have suffecient balance in your account."   
      #redirect_to(new_message_url) 
      #return nil
    #end 
 
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
          
    begin
      if @message.save
         if !params[:students].nil?
	          message = @message.message_body
            params[:students].each do  |student_id|
               student_record = Student.find(student_id)
               student, parent = student_record.name, student_record.parent
               message.gsub!(/@student/, student) 
       	       message.gsub!(/@parent/, parent)
       	       if  params[:message][:scheduled_date].blank?
       	         sms = MessageService.create(:sms => params[:message].merge!({:number => student_record.number})) 
                 message_student = MessageStudent.create(:message_id => @message.id, :student_id => student_id, :sms_id => sms.id)
               elsif  !params[:message][:scheduled_date].blank?
                 sms = MessageSchedule.create(:sms => params[:message].merge!({:number => student_record.number}))  
                 schedule_student = ScheduleStudent.create(:schedule_id => @message.id, :student_id => student_id, :sms_id => sms.id)
               end
               admin.update_attribute('balance', admin.balance.to_i - 1)
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
            admin.update_attribute('balance', admin.balance.to_i - 1)   
	  end
	         flash[:notice] = 'Message is sent for delivery. Please check the status after some time.'
           redirect_to(new_message_url)
         else  #@message.save check
           render :action => "new"
         end 
	   
       rescue #ActiveResource::ResourceInvalid => e  
    	 flash.now[:error] = 'There seems to be a problem in sending message. Please try again.'    
    	 render :action => "new"
       end
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
        msg.update_attribute('status', sms.status) 
     end  
      respond_to do |format|
        flash[:notice] = 'Status successfully updated.'
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
     # balance = admin.balance.to_i - 1
      #if balance <= 0
        #flash[:notice] = "Please ensure you have suffecient balance in your account."   
        #redirect_to message_path(@message) 
        #return nil
     #end 
      message = @message.message_body
      params[:message] = {}
      params[:message][:message_body] = message
      params[:message][:number] =  student_record.number
      student, parent = student_record.name, student_record.parent
      message.gsub!(/@student/, student) 
      message.gsub!(/@parent/, parent)
      sms = MessageService.create(:sms => params[:message]) 
      message_student = MessageStudent.find_by_student_id_and_message_id(student_record.id,@message.id)
      message_student.update_attributes(:message_id => @message.id, :student_id => student_record.id, :sms_id => sms.id,:status => "Sent")
       admin.update_attribute('balance', admin.balance.to_i - 1)
       flash[:notice] = 'Message is sent for delivery. Please check the status after some time.'   
       redirect_to message_path(@message) 
       rescue #ActiveResource::ResourceInvalid => e  
    	 		flash.now[:error] = 'There seems to be a problem in sending message. Please try again.'  
    	  	redirect_to message_path(@message)  
     end
    
   
  
  private
  def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
 end 
  
