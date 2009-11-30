class Schedule < ActiveRecord::Base
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 
 has_many :schedule_students
 has_many :students,:through => :schedule_students
 belongs_to :user
 belongs_to :group
 attr_accessible :scheduled_date,:message_body,:scheduled_time,:group_id,:status,:sms_id,:number
 validates_presence_of :scheduled_date,:message_body,:scheduled_time
                       
end
