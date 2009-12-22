class Group < ActiveRecord::Base
 acts_as_tree :order => "name"
 has_and_belongs_to_many :students
 belongs_to :user
 has_many :messages
 has_many :schedules
 has_many :emails
 has_many :letters
 validates_presence_of  :name
 attr_accessible :name
 #copy students from another group
	def self.copy_students_from_group(group_id,group)
     students = Group.find(group_id).students
  	for student in students
  		group.students << Student.find(student)
  	end
  end 
  
  def self.find_group_all_students(group_id,current_user)
  	@group = current_user.groups.find(group_id)
    @group_students = @group.students
    group_student_ids = @group.students.find(:all).map{|h|h.id}
    unless group_student_ids.blank?
   		 @non_group_students = current_user.students.find(:all,
   		                                                   :conditions => ['id not IN (?)',group_student_ids])
    else
        @non_group_students = current_user.students.find(:all)
     end
    return @group,@group_students,@non_group_students
  end
 
  def self.find_classes_name_message_size(current_user,groups)
     @groups_name = current_user.groups.map{|object|object.name}
	   @groups_message_size  = Array.new(groups.size){Array.new(1)}
     i = 0
    for group in groups
	    @groups_message_size[i][0] = group.messages.size
     i = i+1
	  end
    return @groups_name,@groups_message_size
	end  
	
	def self.find_classes_name_schedule_size(current_user,groups)
     @groups_name = current_user.groups.map{|object|object.name}
	   @groups_schedule_size  = Array.new(groups.size){Array.new(1)}
     i = 0
    for group in groups
	    @groups_schedule_size[i][0] = group.schedules.size
     i = i+1
	  end
    return @groups_name,@groups_schedule_size
	end  
	
	def self.find_classes_name_email_size(current_user,groups)
    @groups_name = current_user.groups.map{|object|object.name}
	   @groups_email_size  = Array.new(groups.size){Array.new(1)}
     i = 0
    for group in groups
	    @groups_email_size[i][0] = group.emails.size
     i = i+1
	  end
    return @groups_name,@groups_email_size
	end  
	
	def self.find_classes_name_letter_size(current_user,groups)
     @groups_name = current_user.groups.map{|object|object.name}
	   @groups_letter_size  = Array.new(groups.size){Array.new(1)}
     i = 0
    for group in groups
	    @groups_letter_size[i][0] = group.letters.size
      i = i+1
	  end
    return @groups_name,@groups_letter_size
	end  
end
