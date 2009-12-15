class Message < ActiveRecord::Base
 has_many :message_students
 has_many :students,:through => :message_students
 belongs_to :user
 belongs_to :group
 belongs_to :tag
 
 attr_accessible :message_body,:number,:status,:sms_id,:tag_id,:group_id
 validates_presence_of :message_body
 
	def self.find_month_wise_report(from_date,to_date,current_user)
       condition = {}
       condition[:created_at] = from_date..to_date
       condition[:user_id] = current_user.id if current_user.has_role?('super_admin')
       condition[:user_id] = user_ids if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
       message = Message.find(:all ,:conditions => condition)
       message_months = message.group_by { |t| t.created_at.beginning_of_month }
       message_months.each_key { |key| reports[key] = message_months[key].size  }
	  end
	
	private
	 def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
	end
