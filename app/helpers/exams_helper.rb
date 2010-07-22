module ExamsHelper
  def get_groups
   school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
   school.groups.find_all_by_status('Active')
  end
  
  def get_subjects_for_exam_group(group)
    ExamSubject.find(:all, :conditions => ['group_id = ? and exam_id = ?', group.id, @exam.id ])
  end
end
