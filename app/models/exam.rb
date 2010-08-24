class Exam < ActiveRecord::Base
# belongs_to :group
 belongs_to :school
 has_many :marks
 has_many :exam_classes
 has_many :exam_subjects
 has_many :groups, :through => :exam_classes
 has_many :subjects, :through => :exam_subjects
 validates_presence_of :exam_type
  
 def self.find_exam_names_and_percentage(student,academic_year,school)
    percentages =[]
    exam_names =[] 
    
    exam_names = Exam.find(:all,:include=>[:exam_classes,:marks],:conditions => ['exam_classes.academic_year_id =? and school_id =? and marks.student_id =?',academic_year.id,school.id,student.id]).map{|object| object.name}.join('|')
   exams =  Exam.find(:all,:include=>[:exam_classes,:marks],:conditions => ['exam_classes.academic_year_id =? and school_id =? and marks.student_id =?',academic_year.id,school.id,student.id])
   subjects = Subject.find(:all,:conditions =>['school_id =?',school.id])
   exams.each do |exam|
    total_maximum_marks =0
    total_marks =0
   subjects.each do |subject|
   maximum_marks = ExamSubject.find(:first,:conditions =>['exam_id =? and subject_id =?',exam.id,subject.id]).maximum_marks rescue 0
    total_maximum_marks+= maximum_marks
    mark= Mark.find(:first,:conditions =>['exam_id =? and subject_id =? and student_id =?',exam.id,subject.id,student.id]).mark rescue 0
    total_marks+= mark
    end
   percentages<<  (total_maximum_marks/100).to_f*total_marks
  end
  return exam_names,percentages
end
end

