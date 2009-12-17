class Tag < ActiveRecord::Base
 belongs_to :user
 has_many   :message_templates
 has_many   :messages
 has_many   :schedules
  
  def self.find_tags_name_message_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_message_size = Array.new(tags.size){Array.new(1)}
     i = 0
    for tag in tags
	   @tags_message_size[i][0] = tag.messages.size 
     i = i+1
	  end
  return @tags_name,@tags_message_size
	end
	 
	 def self.find_tags_name_schedule_size(current_user,tags)
     @tags_name = current_user.tags.map{|object|object.name}
	   @tags_schedule_size = Array.new(tags.size){Array.new(1)}
     i = 0
     for tag in tags
	   	 @tags_schedule_size[i][0] = tag.schedules.size 
       i = i+1
	  end
  return @tags_name,@tags_schedule_size
	end
end
