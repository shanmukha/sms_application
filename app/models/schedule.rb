class Schedule < ActiveRecord::Base
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 belongs_to :user
 belongs_to :group
 belongs_to :tag
 
 attr_accessible :scheduled_date,:message_body,:scheduled_time,:group_id,:status,:sms_id,:number,:tag_id
 attr_accessor :message_id
 validates_presence_of :scheduled_date,:message_body,:scheduled_time
 fires :new_schedule, :on => :create, :actor => :user
   
end
