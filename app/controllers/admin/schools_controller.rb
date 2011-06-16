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

  def edit
   @school = School.find(params[:id])
   @school.administrator || @school.build_administrator
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(params[:school])
     redirect_to admin_schools_path
    else
     render edit_admin_school_path(@school)
    end
  end   
  def show
    @school = School.find(params[:id])
    @user = @school.administrator
    @groups = @school.groups
    @total_no_of_students = Student.find(:all,:include => {:groups => 'school' },:conditions =>['schools.id = ?',params[:id]]).count
    @total_no_of_teachers = User.find(:all,:conditions=>['school_id=?',@school.id]).count
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
