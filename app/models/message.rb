class Message < ActiveRecord::Base
 has_many :message_students
 has_many :students,:through => :message_students
 belongs_to :user
 belongs_to :group
 belongs_to :tag
 
 attr_accessible :message_body,:number,:status,:sms_id,:tag_id,:group_id
 validates_presence_of :message_body
 
	def self.message_send_with_students(message,students,sms,current_user)
  	message_body = message.message_body
    students.each do  |student_id|
    	student_record = Student.find(student_id)
      student, parent = student_record.name, student_record.parent
      message_body.gsub!(/@student/, student) 
      message_body.gsub!(/@parent/, parent)
      if  sms[:scheduled_date].blank? 
       	 sms_object = MessageService.create(:sms => sms.merge!({:number => student_record.number})) 
         message_student = MessageStudent.create(:message_id => message.id,:student_id => student_id,:sms_id => sms_object.id)
      elsif  !sms[:scheduled_date].blank?
          sms_object = MessageSchedule.create(:sms => params[:sms].merge!({:number => student_record.number}))  
          schedule_student = ScheduleStudent.create(:schedule_id => message.id,:student_id => student_id,:sms_id => sms_object.id)
       end
       User.balance_reset(current_user)
       message_body.gsub!(/#{student}/,'@student') 
       message_body.gsub!(/#{parent}/,'@parent') 
     end
  end
   
 end
