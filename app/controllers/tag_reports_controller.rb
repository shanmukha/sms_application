class TagReportsController < ApplicationController
 require 'gchart'
 layout "admin"
 before_filter :check_admin_role
 
  def index
          @tag = {}
        if params[:report].nil?
           @tags = current_user.tags
           @names = []
           @sizes = []
           @tags.each do |tag|
           	 @names << tag.name #for graph 
           	 @tag[tag.id] = tag.messages.count(:all,:conditions => ['created_at>= ?',Time.now.beginning_of_month])
           	 @sizes << @tag[tag.id]
         end
 
    end
  end 
end  
      
