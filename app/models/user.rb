class User < ActiveRecord::Base
  acts_as_authentic
  has_and_belongs_to_many :roles
  has_many :groups
  has_many :message_templates
  has_many :schedules
  has_many  :messages
  has_many  :emails
  has_many :students
  has_many  :letters
 
  def has_role?(role)
   list ||= self.roles.collect(&:name)
   list.include?(role.to_s) 
  end
 
 def self.find_by_username_or_mail_id(username_or_email)
       find(:first, :conditions => ['username = ? OR mail_id = ?', username_or_email, username_or_email])
  rescue
    nil
  end
  
   def forgot_password
    password = "%08d"%rand(99999999) 
    	self.password = password
   	  self.password_confirmation = password
    	self.save
      Notifier.deliver_forgot_password(self)
  end
 end 
