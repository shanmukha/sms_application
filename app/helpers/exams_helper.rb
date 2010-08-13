module ExamsHelper
  def get_groups
   school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
   school.groups.find_all_by_status('Active')
  end
  
  def get_subjects_for_exam_group(group)
    ExamSubject.find(:all, :conditions => ['group_id = ? and exam_id = ?', group.id, @exam.id ])
  end
 def find_marks(exam,group)
  Mark.find(:all,:conditions=>['exam_id =? and group_id =?',exam.id,group.id]) 
 end
 def find_exam_groups(exam)
  groups = exam.groups.find(:all,:conditions=>['status =?','Active']) rescue ""
  return groups
end
end
