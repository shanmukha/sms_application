class Admin::ClassReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
	def index
  	 @class = {}
   	 classes = current_user.find_classes
   	 unless params[:report].nil?
   			@group =  Group.find(params[:report][:group_id]) rescue ""
     		@month =  params[:report][:month]
      	@type = params[:report][:type]  
   	end  
    if params[:report].nil? #default
       @classes = classes
       @names = []
       @sizes = []
       @classes.each do |group|
       	 @names << group.name #for graph 
       	 @class[group.id] = group.messages.count(:all,:joins => [:message_students],:conditions => ['messages.created_at>= ? and message_students.status =?',Time.now.beginning_of_month,'Delivered'])
       	 @sizes << @class[group.id]
      end
    elsif params[:report][:group_id].blank? #all class communication
        @classes = classes
        @class,@names,@sizes = find_all_class_communication(params[:report][:month],params[:report][:type],@classes)
    elsif !params[:report][:group_id].blank? 
          @group = Group.find(params[:report][:group_id])
         	conditions = []
         	conditions += month_conditions(params[:report][:month],params[:report][:type])
      case params[:report][:type]
         
         when 'messages'
              @students,@students_communication_size,@names,@sizes = Student.find_students_communication_size(params[:report][:group_id],conditions,params[:report][:type])    
         
         when 'letters'
               @students,@students_communication_size,@names,@sizes = Student.find_students_communication_size(params[:report][:group_id],conditions,params[:report][:type]) 
                
       when 'emails'
               @students,@students_communication_size,@names,@sizes = Student.find_students_communication_size(params[:report][:group_id],conditions,params[:report][:type]) 
      end       
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
  
  def find_all_class_communication(month,type,classes)
  	conditions = []
    conditions += month_conditions(month,type)
    conditions << ['message_students.status =?','Delivered'] if type == 'messages'
    @names = []
    @sizes = []
    classes.each do |group|
      @names << group.name #for graph 
      @class[group.id] =  group.messages.count(:all,:joins => [:message_students],:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type == 'messages'
      @class[group.id] =  group.emails.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type == 'emails' 
      @class[group.id] =  group.letters.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ) if type == 'letters'
      @sizes << @class[group.id]
    end
     return @class,@names,@sizes
  end
 end
