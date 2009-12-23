class MonthReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
  def index
     user_ids = find_user_ids 
     @messages_size = Message.count(:all,:conditions => ['created_at>= ? and user_id IN (?)',Time.now.beginning_of_month,user_ids])
     @letters_size = Letter.count(:all,:conditions => ['created_at>= ?  and user_id IN (?)',Time.now.beginning_of_month, user_ids])
     @emails_size = Email.count(:all,:conditions => ['created_at>= ? and user_id IN (?)',Time.now.beginning_of_month,user_ids])
     #for graph
     @sizes = []
     @names =['Message','Letter','Email']
     @sizes << @messages_size
     @sizes << @letters_size
     @sizes << @emails_size
   end
   
  
 private
   def find_user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
end
