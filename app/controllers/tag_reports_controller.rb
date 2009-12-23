class TagReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
	def index
 		@tag = {}
    @names = []
    @sizes = []
    tags_object = current_user.tags
     unless params[:report].nil?
   	 @group =  Group.find(params[:report][:group_id]) rescue "All"
     case params[:report][:month]
       when 'tm'
          @month = 'this month'
        when 'lm'
           @month  = 'last month'
        when 'l2'
            @month  = 'last 2 months'
        when  'l3'
             @month  = 'last 3 months'
        when 'l4'
             @month  = 'last 4 months'
         end
           
      end   
    if params[:report].nil? 
      @tags = tags_object
      @tags.each do |tag|
        @names << tag.name #for graph 
         @tag[tag.id] = tag.messages.count(:all,:conditions => ['created_at>= ? and group_id !=?',Time.now.beginning_of_month,""])
         @sizes << @tag[tag.id]
      end
    elsif !params[:report][:group_id].blank?
    	#@group = Group.find(params[:report][:group_id])
      @tags = tags_object
      conditions = []
      conditions << ["group_id = ?", params[:report][:group_id]] if params[:report][:group_id]
      conditions += month_conditions(params[:report][:month])
      @tags.each do |tag|
      	@names << tag.name
        @tag[tag.id] = tag.messages.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
        @sizes << @tag[tag.id]
      end     
   elsif params[:report][:group_id].blank?
   	 @tags = tags_object
     conditions = []
     conditions << ["group_id != ?",""]
     conditions += month_conditions(params[:report][:month])
     @tags.each do |tag|
     	 @names << tag.name
       @tag[tag.id] = tag.messages.count(:all,:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
       @sizes << @tag[tag.id]
    end    
  end
end 

  private
  
  def month_conditions(month)
        condition = []
        case month
           when 'tm'
              condition << ["messages.created_at>= ?",Time.now.beginning_of_month]
           when 'lm'
             condition << ["messages.created_at>= ?",1.months.ago]
          when 'l2' 
             condition << ["messages.created_at>= ?",2.months.ago]
           when 'l3' 
             condition << ["messages.created_at>= ?",3.months.ago]
          when 'l4' 
             condition << ["messages.created_at>= ?",4.months.ago]
      end   
       return condition
     end   
  end
     
     
     
     
     
     
     
     
     
     
     
     
   
