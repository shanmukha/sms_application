class Letter < ActiveRecord::Base
  has_many :letter_students
  has_many :students,:through => :letter_students
  belongs_to :user
  belongs_to :letter
  belongs_to :group
  validates_presence_of  :reference, :content,:group_id
  
  def self.find_month_wise_report(from_date,to_date,current_user)
       reports = {}
       condition = {}
       condition[:created_at] = from_date..to_date
       condition[:user_id] = current_user.id if current_user.has_role?('super_admin')
       condition[:user_id] = User.user_ids(current_user)if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
       letter = Letter.find(:all ,:conditions => condition)
       letter_months = letter.group_by { |t| t.created_at.beginning_of_month }
       letter_months.each_key { |key| reports[key] = letter_months[key].size  }
       return letter_months,reports
	  end

end
