class Student < ActiveRecord::Base
 has_many :message_students
 has_many :messages,:through => :message_students
 has_many :schedule_students
 has_many :schedules,:through => :schedule_students
 has_many :email_students
 has_many :emails,:through => :email_students
 #has_many :student_classes
# has_many :groups,:through => :student_classes
 has_many :letter_students
 has_many :marks
 has_many :letters,:through => :letter_students
 has_one :parent_user,:class_name => 'User'
 belongs_to :user
 has_and_belongs_to_many :groups
 #validates_presence_of  :name,:parent ,:number,:address

	def self.find_student_all_groups(student_id,current_user)
   	student = current_user.students.find(student_id)
    groups = student.groups.find(:all,:conditions =>['user_id =? and status =?',current_user.id,'Active'])
    group_ids =  student.groups.find(:all,:conditions =>['user_id =? and status =?',current_user.id,'Active']).map{|h|h.id}
    unless group_ids.blank?
   		 non_groups = current_user.groups.find(:all,:conditions => ['id not IN (?) and status = ?',group_ids,'Active'])
    else
        non_groups = current_user.groups.find(:all,:conditions =>['status =?','Active'])
     end
     return student,groups,non_groups
 end
  
 def self.find_students_communication_size(group_id,conditions,type) 
	    students_communication_size = {}
      students = Group.find(group_id).students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active'])
      names = []
      sizes = []
      	conditions << ["group_id = ?",group_id] 
        conditions << ['message_students.status =?','Delivered'] if type=="messages"
      students.each do |student|
       names << student.name
       students_communication_size[student.id]  = student.messages.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type=="messages"
      	students_communication_size[student.id] = student.letters.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type=="letters" 
      	students_communication_size[student.id] = student.emails.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size  if type=="emails" 
      	sizes << students_communication_size[student.id]
     end  
     return students,students_communication_size,names,sizes
  end 

	def self.find_student_messages(student)
   	Message.find(:all,
                 :joins =>[:message_students],
                 :conditions =>['message_students.status =? and  message_students.student_id =?','Delivered',student.id]) 

  end
end
