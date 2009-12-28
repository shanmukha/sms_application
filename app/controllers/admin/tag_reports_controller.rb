class Admin::TagReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
	def index
 		@tag = {}
    @names = []
    @sizes = []
    @tags = current_user.tags
    unless params[:report].nil?
   		@month = params[:report][:month]
    end   
    if params[:report].nil? 
      @tags.each do |tag|
        @names << tag.name #for graph 
        @tag[tag.id] = tag.messages.count(:all,:joins => [:message_students],:conditions => ['messages.created_at>= ? and group_id !=?',Time.now.beginning_of_month,""])
        @sizes << @tag[tag.id]
      end
    elsif !params[:report][:group_id].blank?
      conditions = []
      conditions << ["group_id = ?", params[:report][:group_id]] if params[:report][:group_id]
      conditions += month_conditions(params[:report][:month])
      @tags.each do |tag|
      	@names << tag.name
        @tag[tag.id] = tag.messages.count(:all,:joins => [:message_students],:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
        @sizes << @tag[tag.id]
      end     
   elsif params[:report][:group_id].blank?
   	 conditions = []
     conditions << ["group_id != ?",""]
     conditions += month_conditions(params[:report][:month])
     @tags.each do |tag|
     	 @names << tag.name
       @tag[tag.id] = tag.messages.count(:all,:joins => [:message_students],:conditions => [ conditions.transpose.first.join( " and " ), *conditions.transpose.last ] )
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
          condition << ["messages.created_at>= ?",1.months.ago.beginning_of_month]
          condition << ["messages.created_at<= ?",1.months.ago.end_of_month]
       when 'l2' 
         condition << ["messages.created_at>= ?",2.months.ago.beginning_of_month]
       when 'l3' 
          condition << ["messages.created_at>= ?",3.months.ago.beginning_of_month]
       when 'l4' 
          condition << ["messages.created_at>= ?",4.months.ago.beginning_of_month]
      end   
       return condition
     end   
 end
     
     
     
     
     
     
     
     
     
     
     
     
   
