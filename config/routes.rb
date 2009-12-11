ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  map.resources :message_reports,:collection =>{:teacher_messages => :get,:tag_messages => :get,:class_messages => :get,:student_messages => :get}
  map.resources :schedule_reports,:collection => {:student_schedules => :get,:teacher_schedules => :get,:tag_schedules => :get, :class_schedules => :get}
  map.resources :email_reports,:collection => {:teacher_emails => :get,:class_emails => :get,:student_emails => :get,}
  map.resources :letter_reports,:collection => {:student_letters => :get,:teacher_letters => :get,:class_letters => :get,:print => :get}
  map.resources :letters,:collection =>{:group_students => :get},:member => {:print => :any}
  map.resources :emails,:collection =>{:group_students => :get}
  map.resources :schedules,:collection =>{:render_message_template => :get,:student_groups => :get,:edit_student_groups => :get},:member => {:status_update => :any}
  map.resources :groups,:member =>{:add_students => :any,:create_students => :post,:make_active => :get,:make_inactive => :get},:collection =>{:subgroup_new => :any}
  map.resources :message_templates
  map.resources :messages, :collection =>{:render_message_template => :get,:student_groups => :get,:mobile_number => :any},:member => {:status_update => :any}
  map.resources :students
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.resources :user_sessions
  map.resources :users,:collection =>{:forgot_password =>:any}
  map.root :controller => 'messages', :action => 'new'
end
