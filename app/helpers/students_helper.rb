module StudentsHelper

def find_groups(student)
 groups = Student.find(student.id).groups.find(:all,:conditions =>['user_id =? and status =?',current_user.id,'Active']).map{|group|group.name}.join(', ')
 groups||''
end
end
