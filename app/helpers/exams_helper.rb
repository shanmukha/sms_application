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
 def find_subject_marks(exam,group,subject)
   Mark.find(:all,:conditions=>['exam_id =? and group_id =? and subject_id =?',exam.id,group.id,subject.id]) 
 end
 def find_exam_groups(exam)
  groups = exam.groups.find(:all,:conditions=>['status =?','Active']) rescue ""
  return groups
end
 def find_exam_date(clas,subject,exam)
   ExamSubject.find(:first,:conditions =>['group_id =? and subject_id =? and exam_id =?',clas.id,subject.id,exam.id]).exam_date rescue ""
 end
  def find_from_time(clas,subject,exam)
       ExamSubject.find(:first,:conditions =>['group_id =? and subject_id =? and exam_id =?',clas.id,subject.id,exam.id]).from_time rescue ""
end
def find_to_time(clas,subject,exam)
       ExamSubject.find(:first,:conditions =>['group_id =? and subject_id =? and exam_id =?',clas.id,subject.id,exam.id]).to_time rescue ""
end
end
