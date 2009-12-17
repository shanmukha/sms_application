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
  
  def self.find_students_name_message_size(current_user,students)
     @students_name = current_user.students.map{|object|object.name}
	   @students_message_size = Array.new(students.size){Array.new(1)}
     i = 0
    for student in students
	    @students_message_size[i][0] =  student.messages.find(:all).size
       i = i+1
	  end
	  return @students_name,@students_message_size
	end
	
	 def self.find_students_name_schedule_size(current_user,students)
     @students_name = current_user.students.map{|object|object.name}
	   @students_schedule_size = Array.new(students.size){Array.new(1)}
     i = 0
     for student in students
	     @students_schedule_size[i][0] =  student.schedules.find(:all).size
       i = i+1
     end  
    return @students_name,@students_schedule_size
	end
	
	
	 def self.find_students_name_email_size(current_user,students)
     @students_name = current_user.students.map{|object|object.name}
	   @students_email_size = Array.new(students.size){Array.new(1)}
     i = 0
     for student in students
	     @students_email_size[i][0] =  student.emails.find(:all).size
       i = i+1
     end  
    return @students_name,@students_email_size
	end
	
	 def self.find_students_name_letter_size(current_user,students)
     @students_name = current_user.students.map{|object|object.name}
	   @students_letter_size = Array.new(students.size){Array.new(1)}
      i = 0
     for student in students
	     @students_letter_size[i][0] =  student.letters.find(:all).size
       i = i+1
     end  
  return @students_name,@students_letter_size
	end
	
end 
