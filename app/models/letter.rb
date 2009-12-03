class Letter < ActiveRecord::Base
  has_many :letter_students
  has_many :students,:through => :letter_students
  belongs_to :user
  belongs_to :letter
  belongs_to :group
  validates_presence_of  :content,:group_id
end
