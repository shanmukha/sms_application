ActionController::Routing::Routes.draw do |map|
  map.resources :helps 
  map.resources :attendances,:collection => {:group_subject_students => :any,:render_subjects => :any}
  map.resources :letters,:collection =>{:group_students => :get},:member => {:print => :any, :print_labels => :any,:show_letter=>:get}
  map.resources :emails,:collection =>{:group_students => :get},:member => {:show_email=>:get}
  map.resources :schedules,:collection =>{:render_message_template => :get,:student_groups => :get,:edit_student_groups => :get},:member => {:status_update => :any}
  map.resources :groups,:member =>{:add_students => :any,:create_students => :post,:make_active => :get,:make_inactive => :get},:collection =>{:subgroup_new => :any} do |group|
  group.resources :exams,:collection => {:groups => :get,:replace_maximum_marks => :get} do |exam|
  exam.resources :marks,:collection =>{:group_exams => :get},:member => {:mark_individual_subject => :any,:edit_mark_individual_subject =>:any}
  end
 end 
 map.resources :exams
 map.resources :marks,:collection => {:create_mark_individual_subject => :post},:member => {:update_mark_individual_subject => :put}
   map.resources :messages, :collection =>{:render_message_template => :get,:student_groups => :get,:mobile_number => :any},:member => {:status_update => :any,:student_message_resend => :any,:student_message_show => :any,:show_message => :get}
  map.resources :students,:collection => {:import_students_new => :any,:import_students_create => :post,:student_details=>:get},:member => {:student_letter_show => :any,:student_email_show => :any,:student_schedule_show => :any,:student_message_show => :any,:make_active => :get,:make_inactive => :get}
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.resources :user_sessions
  map.root :controller => 'messages', :action => 'new'
  

  map.namespace(:admin) do |admin|
     admin.resources :academic_years
     admin.resources :groups,:member =>{:add_students => :any,:create_students => :post,:make_active => :get,:make_inactive => :get},:collection =>{:subgroup_new => :any} do |group|
      group.resources :student_classes,:collection =>{:promote_students => :any}
       end
     admin.resources :students,:collection => {:import_students_new => :any,:import_students_create => :post,:student_details=>:get},:member => {:student_letter_show => :any,:student_email_show => :any,:student_schedule_show => :any,:student_message_show => :any,:make_active => :get,:make_inactive => :get}
     admin.resources :subjects
     admin.resources :student_classes
     admin.resources :message_templates
     admin.resources :tags
     admin.resources :class_reports
     admin.resources :tag_reports
     admin.resources :teacher_reports
     admin.resources :month_reports 
     admin.resources :attendance_reports,:collection => {:render_subjects => :any}
     admin.resources :schools,:collection=>{:plan_type => :any}
     admin.resources :users,:collection =>{:forgot_password =>:any},:member =>{:edit_my_account => :get}
 end
end 

