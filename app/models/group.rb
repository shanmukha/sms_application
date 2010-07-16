class Group < ActiveRecord::Base
 acts_as_tree :order => "name"
 has_and_belongs_to_many :students
 belongs_to :user
 has_many :messages
 has_many :schedules
 has_many :emails
 has_many :letters
 has_many :subjects
 has_many :exams
 #has_many :student_classes
 #has_many :students,:through => :student_classes
 belongs_to :school
 validates_presence_of  :name
 attr_accessible :name
 #copy students from another group
	def self.copy_students_from_group(group_id,group)
     students = Group.find(group_id).students.find(:all,:conditions =>['status =?','Active'])
  	for student in students
  		group.students << Student.find(student)
  	end
  end 
  
  def self.find_group_all_students(group_id,current_user)
  	@group = current_user.groups.find(group_id)
    @group_students = @group.students.find(:all,:conditions =>['status =?','Active'])
    group_student_ids = @group.students.find(:all,:conditions =>['status =?','Active']).map{|h|h.id}
    unless group_student_ids.blank?
   		 @non_group_students = current_user.students.find(:all,
   		                                                   :conditions => ['id not IN (?) and status =?',group_student_ids,'Active'])
    else
        @non_group_students = current_user.students.find(:all,:conditions =>['status =?','Active'])
     end
    return @group,@group_students,@non_group_students
  end
end
























