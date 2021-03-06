module MarksHelper
def get_subjects_for_exam_group(group,exam)
    ExamSubject.find(:all, :conditions => ['group_id = ? and exam_id = ?', group.id, exam.id ])
  end
def find_mark(group,exam,subject,student)
 mark = Mark.find(:first,:conditions=>['exam_id =? and group_id =? and subject_id =? and student_id =?',exam.id,group.id,subject.id,student.id]).mark rescue ""
 return mark
end
 def find_exam_subjects(exam)
  exam.subjects.find(:all,:group =>:name)
 end
 def find_group_studnets(group)
  group.students.find(:all,:group =>:name,:conditions => ['status =?','Active'])
 end
end
