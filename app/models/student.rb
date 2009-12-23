class Student < ActiveRecord::Base
 has_many :message_students
 has_many :messages,:through => :message_students
 has_many :schedule_students
 has_many :schedules,:through => :schedule_students
 has_many :email_students
 has_many :emails,:through => :email_students
 
 has_many :letter_students
 has_many :letters,:through => :letter_students
 
 belongs_to :user
 has_and_belongs_to_many :groups
 validates_presence_of  :name,:parent ,:number,:address
 
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
      students = Group.find(group_id).students
      names = []
      sizes = []
      students.each do |student|
      	names << student.name
      	students_communication_size[student.id]  = student.messages.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type=="messages"
      	students_communication_size[student.id] = student.letters.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type=="letters" 
      	students_communication_size[student.id] = student.emails.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size  if type=="emails" 
      	sizes << students_communication_size[student.id]
        return students,students_communication_size,names,sizes
      end  
end 
end
