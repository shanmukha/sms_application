class ClassReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
	
   def index
         @class = {}
        if params[:report].nil?
           @classes = current_user.find_classes
           @names = []
           @sizes = []
           @classes.each do |group|
           @names << group.name #for graph 
           @class[group.id] = group.messages.find(:all,:conditions => ['created_at>= ? and created_at <= ?',Time.now.beginning_of_month,Time.now]).size
           @sizes << @class[group.id]
         end
    elsif params[:report][:group_id].blank? 
        @classes = current_user.find_classes
        @class,@names,@sizes = find_all_class_communication(params[:report][:month],params[:report][:type],@classes)
    elsif !params[:report][:group_id].blank? 
         @group = Group.find(params[:report][:group_id])
         conditions = []
         conditions << ["group_id = ?", params[:report][:group_id]] if params[:report][:group_id]
         conditions += month_conditions(params[:report][:month],params[:report][:type])
      case params[:report][:type]
         when 'messages'
               @communication = Message.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
               @students,@students_communication_size,@names,@sizes = Student.find_students_communication_size(params[:report][:group_id],conditions,params[:report][:type])    
                  
        when 'letters'
                @communication = Letter.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
               @students,@students_communication_size,@names,@sizes = Student.find_students_communication_size(params[:report][:group_id],conditions,params[:report][:type]) 
                
      when 'emails'
                @communication = Email.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
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
             condition << ["#{type}.created_at>= ?",1.months.ago]
          when 'l2' 
             condition << ["#{type}.created_at>= ?",2.months.ago]
           when 'l3' 
             condition << ["#{type}.created_at>= ?",3.months.ago]
          when 'l4' 
             condition << ["#{type}.created_at>= ?",4.months.ago]
      end   
       return condition
     end   
     
     def  find_all_class_communication(month,type,classes)
           conditions = []
           conditions += month_conditions(month,type)
           @names = []
           @sizes = []
          classes.each do |group|
           @names << group.name #for graph 
           @class[group.id] =  group.messages.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'messages'
           @class[group.id] =  group.emails.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'emails' 
           @class[group.id] =  group.letters.find(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] ).size if type == 'letters'
           @sizes << @class[group.id]
  end
  return @class,@names,@sizes
  
end

end
