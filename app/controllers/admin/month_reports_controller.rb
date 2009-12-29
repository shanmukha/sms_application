class Admin::MonthReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
  def index
     @sizes = []
     @names =['Message','Letter','Email']
     user_ids = find_user_ids 
     if params[:report].nil? #default values
     		@messages_size = Message.count(:all,:joins => [:message_students],:conditions => ['messages.created_at>= ? and messages.user_id IN (?) and message_students.status =?',Time.now.beginning_of_month,user_ids,'Delivered'])
     		@letters_size = Letter.count(:all,:conditions => ['created_at>= ?  and user_id IN (?)',Time.now.beginning_of_month, user_ids])
        @emails_size = Email.count(:all,:conditions => ['created_at>= ? and user_id IN (?)',Time.now.beginning_of_month,user_ids])
     #for graph
       @sizes << @messages_size
       @sizes << @letters_size
       @sizes << @emails_size
    elsif ![:report].nil?
       @month = params[:report][:month]
       @messages_size = find_communication_size(@month,'messages')
       @letters_size = find_communication_size(@month,'letters')
       @emails_size = find_communication_size(@month,'emails')
    	 @sizes << @messages_size
       @sizes << @letters_size
       @sizes << @emails_size
    end
    
  end 
  
  private
   def find_user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
 	
 	def find_communication_size(month,type)
     conditions = []
     conditions << ['user_id IN (?)',find_user_ids]
     conditions << ['message_students.status =?','Delivered'] if type == 'messages'
     case month
       when 'tm'
         conditions << ["#{type}.created_at>= ?",Time.now.beginning_of_month]
       when 'lm'
         conditions << ["#{type}.created_at>= ?",1.months.ago.beginning_of_month]
         conditions << ["#{type}.created_at<= ?",1.months.ago.end_of_month]
       when 'l2' 
         conditions << ["#{type}.created_at>= ?",2.months.ago.beginning_of_month]
       when 'l3' 
         conditions << ["#{type}.created_at>= ?",3.months.ago.beginning_of_month]
        when 'l4' 
          conditions << ["#{type}.created_at>= ?",4.months.ago.beginning_of_month]
    end 
       @size = Message.count(:all,:joins => [:message_students],:conditions => [conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type =='messages'
      @size = Letter.count(:all,:conditions => [conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type == 'letters'
      @size = Email.count(:all,:conditions => [conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )  if type == 'emails'
     return @size
  end
 end 
