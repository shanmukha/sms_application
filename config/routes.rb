ActionController::Routing::Routes.draw do |map|
  

  map.resources :helps
  map.resources :letters,:collection =>{:group_students => :get},:member => {:print => :any, :print_labels => :any}
  map.resources :emails,:collection =>{:group_students => :get}
  map.resources :schedules,:collection =>{:render_message_template => :get,:student_groups => :get,:edit_student_groups => :get},:member => {:status_update => :any}
  map.resources :groups,:member =>{:add_students => :any,:create_students => :post,:make_active => :get,:make_inactive => :get},:collection =>{:subgroup_new => :any}
   map.resources :messages, :collection =>{:render_message_template => :get,:student_groups => :get,:mobile_number => :any},:member => {:status_update => :any,:student_message_resend => :any,:student_message_show => :any}
  map.resources :students,:collection => {:import_students_new => :any,:import_students_create => :post},:member => {:student_letter_show => :any,:student_email_show => :any,:student_schedule_show => :any,:student_message_show => :any,:make_active => :get,:make_inactive => :get}
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.resources :user_sessions
  map.root :controller => 'messages', :action => 'new'

  map.namespace(:admin) do |admin|
     admin.resources :subjects
     admin.resources :message_templates
     admin.resources :tags
     admin.resources :class_reports
     admin.resources :tag_reports
     admin.resources :teacher_reports
     admin.resources :month_reports 
     admin.resources :users,:collection =>{:forgot_password =>:any,:client_type => :any}
 end
end 

