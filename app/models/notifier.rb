class Notifier < ActionMailer::Base

def email_notification(email,current_user,student)
    @recipients ="#{student.email}"
    @from     =  "shanmukhakatta@gmail.com"
    @subject   = "#{email.subject}"
    @sent_on   = Time.now
    @body["text" ] = "#{email.body}"
    
end

 def forgot_password(user)
    @recipients ="#{user.mail_id}"
    @from     =  "admin@schoolit.com"
    @sent_on   = Time.now
    @subject  =  "New pasword of school it"
    @body[:user]  = user
    @body[:url] = "http://localhost:3000/login"
  end
  

end
