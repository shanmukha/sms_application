class Admin::SchoolsController < ApplicationController
  layout "admin"
   
  def index
    @schools = School.find(:all)
  end

  def new
    @school = School.new
    @school.build_administrator
  end

  def create
    @school = School.new(params[:school])
    if @school.save
     admin =  @school.administrator
     admin.roles << Role.find(:first,:conditions=>['name =?','admin'])
     admin.save
     redirect_to admin_schools_path
    else
      render :action => "new"
    end
  end

  def show
    @school = School.find(params[:id])
    @user = @school.administrator
  end

  def plan_type
    plan_type = params[:plan_type]
    render :update do |page|
       page.replace_html 'type', :partial => 'balance' if plan_type == "Limited"
       page.replace_html 'type', :partial => 'end_date' if plan_type == "Unlimited"
       page.replace_html 'type', :partial => 'blank' if plan_type == ""
    end
 end 
end
