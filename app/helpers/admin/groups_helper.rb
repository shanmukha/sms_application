module Admin::GroupsHelper

 def all_groups
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) rescue ''
     [['Select class', '']] + admin.groups.find(:all,:conditions =>['status = ?','Active']).map{|m|[m.name,m.id]} rescue ''
   end
 def find_roll_number(group,student)
   StudentClass.find(:first,:conditions =>['group_id = ? and student_id = ?',group.id,student.id]).roll_number rescue ''
end
 def find_all_teachers
  [['Select teacher', '']] + User.find(:all,:conditions =>['parent_id =?',current_user.id]).map{|t|[t.name,t.id]} rescue ''
end
def find_teacher(group_subject,group)
  a = ClassSubject.find(:first,:conditions =>['subject_id =? and group_id=?',group_subject.id,group.id]).handled_by_id rescue ''
a
end
def find_subject_handled_by(group,subject)
 a = ClassSubject.find(:first,:conditions =>['subject_id =? and group_id=?',subject.id,group.id]).handled_by_id rescue ''
 b = User.find(a).name rescue ''
return b
end
end
