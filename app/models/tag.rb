class Tag < ActiveRecord::Base
 belongs_to :user
 has_many   :message_templates
 has_many   :messages
 has_many   :schedules
 
 end
