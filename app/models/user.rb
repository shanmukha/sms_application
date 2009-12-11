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
  
  def self.find_teachers_name_message_size(current_user,teachers)
     @teachers_name = find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|object.name}
	   @teachers_message_size = []
	  # @colors1 = 0xFF0000
	   #@colors1 = dec2hex(@colors1)
	  # i = 0
	   for teacher in teachers
	      @teachers_message_size << teacher.messages.size
	   #		@colors1 = @colors1 + 0xaaaaaa
	   	#	@colors1 = dec2hex(@colors1)
       #	@colors = "#{@colors1},#{@colors}" if i!=0
       	#@colors = "#{@colors1}" if i==0
       	#@colors1.hex
       	#@colors1 = Integer("0x" + @colors1 )
        #i = i+1
      end
  return @teachers_name,@teachers_message_size
	end  

 def forgot_password
    password = "%08d"%rand(99999999) 
    	self.password = password
   	  self.password_confirmation = password
    	self.save
      Notifier.deliver_forgot_password(self)
  end
 end 
 
private
 
 def dec2hex(number)
   number = Integer(number);
   hex_digit = "0123456789ABCDEF".split(//);
   ret_hex = '';
   while(number != 0)
      ret_hex = String(hex_digit[number % 16 ] ) + ret_hex;
      number = number / 16;
   end
   return ret_hex; ## Returning HEX
end
