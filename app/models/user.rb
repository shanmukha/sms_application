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
  has_many  :subjects
  belongs_to  :school
  validates_presence_of :mail_id,:name
  validates_format_of :mail_id,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i
                     
                      
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
  
 def self.set_default_template_tag(current_user,user)
     @message_templates = current_user.message_templates
     @tags = current_user.tags
      unless @tags.nil? 
       @tags.each do |tag|
     		 Tag.create(:name => tag.name,:description => tag.description,:user_id => user.id)
       end
     end 
     unless @message_templates.nil?
     	 @message_templates.each do |template|
     	    tag_name = template.tag.name
     	    tag_id = Tag.find(:first,:conditions => ['name =? and user_id =?',tag_name,user.id]).id
       		MessageTemplate.create(:message_body => template.message_body,:message_title => template.message_title,:tag_id => tag_id,:user_id => user.id) 
      end
     end
 end     	

  def self.create_row(username,password,student,current_user,school_id)
    user = User.new
    user.name = student.parent
    user.designation = "Parent Login"
    user.username = username
    user.password = password
    user.password_confirmation = password
    user.mail_id = student.email
    user.school_id = school_id
    user.roles << Role.find(:first,:conditions=>['name =?','parent'])
    user.save
    student.update_attributes(:parent_user_id=>user.id)
    Notifier.deliver_email_notification_for_parent(student.email,username,password,student.name,current_user)
  end
 end
