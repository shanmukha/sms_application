class Schedule < ActiveRecord::Base
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 belongs_to :user
 belongs_to :group
 belongs_to :tag
 
 attr_accessible :scheduled_date,:message_body,:scheduled_time,:group_id,:status,:sms_id,:number,:tag_id
 validates_presence_of :scheduled_date,:message_body,:scheduled_time
  
  def self.find_month_wise_report(from_date,to_date,current_user)
       reports = {}
       condition = {}
       condition[:created_at] = from_date..to_date
       condition[:user_id] = current_user.id if current_user.has_role?('super_admin')
       condition[:user_id] = User.user_ids(current_user)if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
       schedule = Schedule.find(:all ,:conditions => condition)
       schedule_months = schedule.group_by { |t| t.created_at.beginning_of_month }
       schedule_months.each_key { |key| reports[key] = schedule_months[key].size  }
       return schedule_months,reports
	  end                      
end
