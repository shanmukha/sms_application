class Tag < ActiveRecord::Base
 belongs_to :user
 has_many   :message_templates
 has_many   :messages
 has_many   :schedules
  
  def self.find_all_tags(current_user)
     user_ids = []
     user_ids << 1
     user_ids << current_user.id
	   find(:all,:conditions =>['user_id in (?)',user_ids])
  end
end  
