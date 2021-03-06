class Admin::TeacherReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
  
 	def index
  	@teacher = {} 
    unless params[:report].nil?
   	  @month = params[:report][:month]
      @type = params[:report][:type]  
    end  
    
    if params[:report].nil?
       @teachers = User.find_teachers(current_user) #not checking super_admin
       @names = []
       @sizes = []
       @teachers.each do |teacher|
       	  @names << teacher.name #for graph 
          @teacher[teacher.id] = teacher.messages.count(:all,:joins => [:message_students],:conditions => ['messages.created_at>= ? and message_students.status =?',Time.now.beginning_of_month,'Delivered'])
          @sizes << @teacher[teacher.id]
         	end
    else
          @teachers = User.find_teachers(current_user)
          @teacher,@names,@sizes = find_all_teacher_communication(params[:report][:month],params[:report][:type],@teachers)
     end   
 end

private
	
	def month_conditions(month,type)
  	condition = []
    case month
    	when 'tm'
         condition << ["#{type}.created_at>= ?",Time.now.beginning_of_month]
      when 'lm'
          condition << ["#{type}.created_at>= ?",1.months.ago.beginning_of_month]
          condition << ["#{type}.created_at<= ?",1.months.ago.end_of_month]
      when 'l2' 
          condition << ["#{type}.created_at>= ?",2.months.ago.beginning_of_month]
      when 'l3' 
           condition << ["#{type}.created_at>= ?",3.months.ago.beginning_of_month]
      when 'l4' 
           condition << ["#{type}.created_at>= ?",4.months.ago.beginning_of_month]
   end   
        return condition
 end   
     
     def  find_all_teacher_communication(month,type,teachers)
           conditions = []
           conditions += month_conditions(month,type)
           conditions << ['message_students.status =?','Delivered'] if type == 'messages'
           @names = []
           @sizes = []
           teachers.each do |teacher|
           	 @names << teacher.name #for graph 
             @teacher[teacher.id] =  teacher.messages.find(:all,:joins => [:message_students],:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'messages'
             @teacher[teacher.id] =  teacher.emails.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'emails' 
             @teacher[teacher.id] =  teacher.letters.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'letters'
             @sizes << @teacher[teacher.id]
       end
    return @teacher,@names,@sizes
  end
end
