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
    y_axis = "0|25|50|75|100"
    exam_names = Exam.find(:all,:include=>[:exam_classes,:marks],:conditions => ['exam_classes.academic_year_id =? and school_id =? and marks.student_id =?',academic_year.id,school.id,student.id]).map{|object| object.name}.join('|')
   exams =  Exam.find(:all,:include=>[:exam_classes,:marks],:conditions => ['exam_classes.academic_year_id =? and school_id =? and marks.student_id =?',academic_year.id,school.id,student.id])
   subjects = Subject.find(:all,:conditions =>['school_id =?',school.id])
   exams.each do |exam|
    total_maximum_marks =0
    total_marks =0
   subjects.each do |subject|
   mark= Mark.find(:first,:conditions =>['exam_id =? and subject_id =? and student_id =?',exam.id,subject.id,student.id]) rescue ""
    total_marks= total_marks + mark.mark unless mark.blank?
   total_maximum_marks= total_maximum_marks + mark.subject.max_marks  unless mark.blank?
    end
   percentages<<  total_marks/total_maximum_marks.to_f*100 rescue 0
  end
  return exam_names,percentages,exams
end
end

