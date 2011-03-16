class Group < ActiveRecord::Base
 belongs_to :user
 has_many :marks 
 has_many :messages
 has_many :schedules
 has_many :emails
 has_many :letters
 has_many :subjects
 has_many :class_subject_attendances
 has_many :student_classes
 has_many :students,:through => :student_classes
 has_many :exam_classes
 has_many :exams,:through => :exam_classes
 has_many :class_subjects
 has_many :subjects,:through => :class_subjects
 belongs_to :school
 validates_presence_of  :name
 attr_accessible :name
 fires :new_group, :on => :create, :actor => :user
 fires :edit_group, :on => :update, :actor => :user
#copy students from another group
  def self.copy_students_from_group(group_id,group,current_user)
     school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
     academic_year = AcademicYear.current_academic_year_school(school.id)
     students = Group.find(group_id).students.find(:all,:conditions =>['status =?','Active'])
  	for student in students
  	 StudentClass.create(:student_id => student.id,:group_id => group.id,:academic_year_id => academic_year.id) 	
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
  
  def self.find_group_all_subjects(group_id,current_user)
       school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
       @group = school.groups.find(group_id)
       @group_subjects = @group.subjects.find(:all)
       group_subject_ids = @group.subjects.find(:all).map{|h|h.id}
      unless group_subject_ids.blank?
       @non_group_subjects = school.subjects.find(:all,:conditions => ['id not IN (?)',group_subject_ids])
     else
       @non_group_subjects = school.subjects.find(:all)
     end
    return @group,@group_subjects,@non_group_subjects
  end   
end
























