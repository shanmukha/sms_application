module MarksHelper
def get_subjects_for_exam_group(group,exam)
    ExamSubject.find(:all, :conditions => ['group_id = ? and exam_id = ?', group.id, exam.id ])
  end
end
