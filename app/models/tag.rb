class Tag < ActiveRecord::Base
 belongs_to :user
 has_many   :message_templates
 has_many   :messages
 has_many   :schedules
 fires :new_tag, :on => :create, :actor => :user
 fires :edit_tag, :on => :update, :actor => :user
end
