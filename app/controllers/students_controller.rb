class StudentsController < ApplicationController
  layout "main",:except => [:show,:import_students_new]
  before_filter :check_admin_role, :except =>[:index,:show]
	require "csv"
	def index
	  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
    @search = Student.search(params[:search])
    @search.user_id = admin.id 
    @search.order ||= "descend_by_created_at"
    @students = @search.all.paginate :page => params[:page],:per_page => 25
    @groups = admin.groups.find(:all,:conditions =>['status =?','Active'])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end
	
  def show
	  admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
    @student = admin.students.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  def new
    @student = Student.new
    @groups = current_user.groups.find(:all,:conditions =>['status =?','Active'])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end
	
  def edit
    @student,@groups,@non_groups = Student.find_student_all_groups(params[:id],current_user)
  end
	
  def create
    @student = Student.new(params[:student])
    @student.user_id = current_user.id
    respond_to do |format|
      if @student.save
      unless params[:groups].nil?
        params[:groups].each do|group|
        	@student.groups<< Group.find(group)
       end
      end
        flash[:notice] = 'Student record is successfully created.'
         format.html { redirect_to(students_url) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = current_user.students.find(params[:id])
    groups  = params[:groups]
     @student.groups.clear
     respond_to do |format|
      if @student.update_attributes(params[:student])
       unless groups.nil?
        	groups.each do  |group_id|
        		@student.groups << Group.find(group_id)
        	end
        end
        flash[:notice] = 'Student record is successfully updated.'
        format.html { redirect_to(students_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = current_user.students.find(params[:id])
    @student.destroy
    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
  
  def import_students_new 
  
  end
  
  def import_students_create
  	@parsed_file =  CSV::Reader.parse(params[:students][:file])
    @parsed_file.each do |row|
     	Student.create(:roll_number => row[0],:name => row[1],:parent => row[2],:address => row[3],:number => row[4],:email => row[5],:user_id => current_user.id) 
    end
     respond_to do |format|
     		flash[:notice] = 'Student record is successfully imported.'
     		format.html { redirect_to(students_url) }
      	format.xml  { head :ok }
    end
    end
end  
