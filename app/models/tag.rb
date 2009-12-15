class Tag < ActiveRecord::Base
 belongs_to :user
 has_many   :message_templates
 has_many   :messages
 has_many   :schedules
  
  def self.find_tags_name_message_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_message_size = []
	   for tag in tags
	   		@tags_message_size << tag.messages.size
	  end
  return @tags_name,@tags_message_size
	end
	 
	 def self.find_tags_name_schedule_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_schedule_size = []
	   for tag in tags
	   		@tags_schedule_size << tag.schedules.size
	  end
  return @tags_name,@tags_schedule_size
	end
	 
	 def self.find_tags_name_email_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_email_size = []
	   for tag in tags
	   		@tags_email_size << tag.emails.size
	  end
  return @tags_name,@tags_email_size
	end
	
	 def self.find_tags_name_letter_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_letter_size = []
	   for tag in tags
	   		@tags_letter_size << tag.letters.size
	  end
  return @tags_name,@tags_letter_size
	end
 end
