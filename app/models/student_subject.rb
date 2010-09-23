class StudentSubject < ActiveRecord::Base
 belongs_to :student
 belongs_to :subject
end
