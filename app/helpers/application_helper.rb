# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 def message_body_filter(body)
    body.slice!(0,400) + "..." unless body.nil?
  end
  
  def all_templates 
      admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
     [['Select saved message', '']] + admin.message_templates.find(:all).map{|m|[m.message_title,m.id]}
  end
	
	def all_tags
	  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
	  [['Select tag', '']] + admin.tags.find(:all).map{|m|[m.name,m.id]} rescue ''
	end
	
	
  def all_groups
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
     [['Select class', '']] + admin.groups.find(:all,:conditions =>['status = ?','Active']).map{|m|[m.name,m.id]} rescue ''
   end

  
   
   def find_message_status(message,student)
      MessageStudent.find(:first,:conditions =>['message_id = ? and student_id = ?',message,student]).status rescue ''
   end
    
    def find_schedule_status(schedule,student)
      ScheduleStudent.find(:first,:conditions =>['schedule_id = ? and student_id = ?',schedule,student]).status rescue ''
   end
  
    def month_print(month)
      month_name= ["nil","January"," February"," March"," April"," May"," June"," July"," August"," September"," October"," November"," December"]
      return month_name[month]
     end
    
	def display(month)
     case month
       when 'tm'
         month_name = "in the month of #{month_print(Time.now.month)}-#{Time.now.strftime('%y')}"
       when 'lm'
          month_name = "in the month of #{month_print(1.months.ago.month)}-#{Time.now.strftime('%y')}"
       when 'l2' 
          month_name =  "during #{month_print(1.months.ago.month)} and  #{month_print(Time.now.month)}"
       when 'l3'
           month_name = "from #{month_print(2.months.ago.month)} till  #{month_print(Time.now.month)}"       
       when 'l4'
           month_name =  "from #{month_print(3.months.ago.month)} till #{month_print(Time.now.month)}"
    end       
       return month_name  
   end 
       
    def column_class(status)
      class_name = case status
                     when "Sent" then "yellow"
                     when  "Scheduled" then "yellow"
                     when "Delivered" then "green"
                     when "Failed" then "red"
                     when "Invalid mobile number" then 'orange'
                     else 'red'
         end
        return class_name
  end

 def disabled(status)
   disable = case status
              when "Sent" then true
              when "Scheduled" then true
              when "Delivered" then true
              when "Failed" then false
              when "  TATU 018" then false
              when "Invalid mobile number" then false
              else true
         end
    return disable
 end
    
    def find_all_tags
	  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
	    [['All', '']] + admin.tags.find(:all).map{|m|[m.name,m.id]} rescue ''
	  end
	
	
  def find_all_groups
     admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
    [['All', '']] +  admin.groups.find(:all,:conditions =>['status = ?','Active']).map{|m|[m.name,m.id]} rescue ''
  end

  def find_all_subjects
   admin = current_user.has_role?('admin') ? current_user : User.find (current_user.parent_id) rescue ''
    school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
   subjects=  Subject.find(:all,:order => "created_at DESC",:conditions=>['school_id =?',school.id]).find(:all).map{|m|[m.name,m.id]} rescue ''
    return subjects
  end

  def all_groups
     groups = Group.find(:all,:conditions =>['school_id =?',current_user.school_id]).collect {|e| [e.name,e.id]} rescue ''
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

  def find_school(current_user)
   if current_user.has_role?('admin')
     school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
   elsif current_user.has_role?('teacher')
     school = School.find(current_user.school_id)
   end
  end

  def change_format_to_long(object)
   date = object.nil? ? object : object.to_s(:long)
   date 
  end

  def find_groups(student)
  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
  school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
  academic_year = AcademicYear.current_academic_year_school(school.id)
 groups = Student.find(student.id).groups.find(:last,:include =>[:student_classes],:conditions =>['user_id =? and status =? and student_classes.academic_year_id = ?',admin.id,'Active',academic_year.id]).name
end


end
