class Email < ActiveRecord::Base
 	has_many :email_students
	has_many :students,:through => :email_students
  belongs_to :user
  belongs_to :group
  validates_presence_of  :subject,:body,:group_id
   fires :new_email, :on => :create, :actor => :user
end 
 
 
