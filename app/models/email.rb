class Email < ActiveRecord::Base
 has_many :email_students
 has_many :students,:through => :email_students
 belongs_to :user
 belongs_to :group
 validates_presence_of  :subject,:body,:group_id
 
 def self.find_month_wise_report(from_date,to_date,current_user)
       reports = {}
       condition = {}
       condition[:created_at] = from_date..to_date
       condition[:user_id] = current_user.id if current_user.has_role?('super_admin')
       condition[:user_id] = User.user_ids(current_user)if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
       email = Email.find(:all ,:conditions => condition)
       email_months = email.group_by { |t| t.created_at.beginning_of_month }
       email_months.each_key { |key| reports[key] = email_months[key].size  }
       return email_months,reports
	  end
 end
