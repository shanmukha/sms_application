class GroupsController < ApplicationController
  layout "main"
  before_filter :check_admin_role, :except =>[:index,:show]

 	def index
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) 
    @search =  Group.search(params[:search]) 
    @search.user_id = admin.id
    @search.order ||= "ascend_by_name_status"
    @groups = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end
	
	def show
	   admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
     @group = admin.groups.find(params[:id])
     @students = @group.students.find(:all)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end
	
  def new
    @group = Group.new
    @students = current_user.students.find(:all,:conditions =>['status =?','Active'])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end
	
   def edit
    @group,@group_students,@non_group_students = Group.find_group_all_students(params[:id],current_user)
  end
	
 def create
    @group = current_user.groups.new(params[:group])
    students = params[:students]
    respond_to do |format|
      school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
      @group.school_id = school.id
      academic_year = AcademicYear.current_academic_year_school(school.id)
      if @group.save
      	unless students.blank?
          students.each do  |student|
          StudentClass.create(:student_id => student,:group_id => @group.id,:academic_year_id => academic_year.id)
         end
      end
       Group.copy_students_from_group(params[:group_id],@group,current_user) unless params[:group_id].blank?
       flash[:notice] = "#{@group.name} record is successfully created."
       format.html { redirect_to(groups_url) }
       format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

     def update
       @group = current_user.groups.find(params[:id])
       students = params[:students]
       StudentClass.delete_all(["group_id = ?", @group.id])
       school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
       academic_year = AcademicYear.current_academic_year_school(school.id)
      respond_to do |format|
      if @group.update_attributes(params[:group])
      	unless students.nil?
          students.each do  |student|
            StudentClass.create(:student_id => student,:group_id => @group.id,:academic_year_id => academic_year.id,:roll_number => params[:roll_numbers]["#{student}"][:roll])
          end
        end
        flash[:notice] = "#{@group.name} is successfully updated."
         format.html { redirect_to(groups_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	def make_active
  	group = current_user.groups.find(params[:id])
   	group.status = "Active"
   	group.save
    respond_to do |format|
      flash[:notice] = "#{group.name} is successfully activated."
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
 end
end
  
  def make_inactive
   group = current_user.groups.find(params[:id])
   group.status = "Inactive"
   group.save
   respond_to do |format|
       flash[:notice] = "#{group.name} is successfully inactivated."
       format.html { redirect_to(groups_url) }
       format.xml  { render :xml => @group, :status => :created, :location => @group }
    end
  end
 
  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
