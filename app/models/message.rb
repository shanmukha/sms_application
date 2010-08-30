class Message < ActiveRecord::Base
 has_many :message_students
 has_many :students,:through => :message_students
 belongs_to :user
 belongs_to :group
 belongs_to :tag
 
 attr_accessible :message_body, :number, :status, :sms_id, :tag_id, :group_id, :message_id, :scheduled_date
 attr_accessor :message_id, :scheduled_date

 validates_presence_of :message_body
 fires :new_message, :on => :create, :actor => :user
end
