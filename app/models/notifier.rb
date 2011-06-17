class Notifier < ActionMailer::Base

def email_notification(email, current_user, student)
    recipients    "#{student.email}"
    from          current_user.mail_id
    subject       email.subject
    sent_on       Time.now
    reply_to      current_user.mail_id
    content_type  "text/html"
    body          :email => email
end


def email_notification_for_parent(email,username,password,student_name,current_user)
    recipients    email
    from          current_user.mail_id
    subject       "Login Details"
    body          :username => username,:password => password, :student_name => student_name
end


 def forgot_password(user)
    @recipients ="#{user.mail_id}"
    @from     =  "admin@schoolit.com"
    @sent_on   = Time.now
    @subject  =  "New pasword of school it"
    @body[:user]  = user
    @body[:url] = "http://www.schoolit.in/login"
  end
end
