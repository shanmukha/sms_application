class Letter < ActiveRecord::Base
  has_many :letter_students
  has_many :students,:through => :letter_students
  belongs_to :user
  belongs_to :group
  validates_presence_of  :reference, :content,:group_id
  fires :new_letter, :on => :create, :actor => :user
end
