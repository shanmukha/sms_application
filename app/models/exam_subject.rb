class ExamSubject < ActiveRecord::Base
  belongs_to :subject
  belongs_to :exam
  belongs_to :group
  
end
