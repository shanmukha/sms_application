# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 def message_body_filter(body)
 		unless body.nil?
 		body.slice!(0,40)
        end
  end
  
  def all_templates
	  current_user.message_templates.find(:all).map{|m|[m.message_title,m.id]}
	end
	
	def all_tags
	  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
	  admin.tags.find(:all).map{|m|[m.name,m.id]} rescue ''
	end
	
	
	def all_groups
	    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
      admin.groups.find(:all,:conditions =>['status = ?','Active']).map{|m|[m.name,m.id]} rescue ''
   end
   
   def find_message_status(message,student)
      MessageStudent.find(:first,:conditions =>['message_id = ? and student_id = ?',message,student]).status rescue ''
   end
    
    def find_schedule_status(schedule,student)
      ScheduleStudent.find(:first,:conditions =>['schedule_id = ? and student_id = ?',schedule,student]).status rescue ''
   end
   def find_teacher_messages(teacher)
  	teacher.messages
 end 
  
 def find_tag_messages(tag)
    tag.messages
  end
 
 def find_class_messages(group)
   group.messages
 end
  
  def find_student_messages(student)
    student.messages.find(:all)
  end
   
 	def find_teacher_schedules(teacher)
    teacher.schedules 
  end
  
  def find_student_schedules(student)
      student.schedules.find(:all)
  end
  
  def find_tag_schedules(tag)
    tag.schedules
  end
 
  def find_class_schedules(group)
     group.schedules 
  end
   
  def find_teacher_emails(teacher)
      teacher.emails
  end 
  
  def  find_class_emails(group)
       group.emails
  end
  
  def find_student_emails(student)
      student.emails.find(:all)
   end    
  
  def find_teacher_letters(teacher)
      teacher.letters
  end
  
  def find_class_letters(group)
     group.letters
  end   
  
  def find_student_letters(student)
       student.letters.find(:all) 
  end
end
