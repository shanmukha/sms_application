module ExamsHelper
  def get_groups
    current_user.school.groups.find_all_by_status('Active')
  end
  
  def get_subjects_for_exam_group(group)
    ExamSubject.find(:all, :conditions => ['group_id = ? and exam_id = ?', group.id, @exam.id ])
  end
end
