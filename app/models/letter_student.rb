class LetterStudent < ActiveRecord::Base
  belongs_to :student
  belongs_to :letter
end
