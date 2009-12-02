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
end
