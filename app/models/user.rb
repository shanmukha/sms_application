class User < ActiveRecord::Base
  acts_as_authentic
  has_and_belongs_to_many :roles
  has_many  :groups
  has_many  :message_templates
  has_many  :schedules
  has_many  :messages
  has_many  :emails
  has_many  :students
  has_many  :letters
  has_many  :tags
  def has_role?(role)
   list ||= self.roles.collect(&:name)
   list.include?(role.to_s) 
  end
 
 def self.find_by_username_or_mail_id(username_or_email)
       find(:first, :conditions => ['username = ? OR mail_id = ?', username_or_email, username_or_email])
  rescue
    nil
  end
  
  def self.find_teachers(current_user)
      User.find(:all,:conditions =>['parent_id = ?',current_user.id])
  end
  

 def forgot_password
    password = "%08d"%rand(99999999) 
    	self.password = password
   	  self.password_confirmation = password
    	self.save
      Notifier.deliver_forgot_password(self)
  end
 
 def self.user_ids(current_user)
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
  
  def find_classes
   self.groups.find(:all ,:conditions => ['status = ?','Active'])
  end
end
