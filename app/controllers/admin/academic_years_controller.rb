class Admin::AcademicYearsController < ApplicationController
  layout "admin"
  before_filter :check_admin_role
  def index
   school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
    @academic_years = AcademicYear.find(:all,:order => "created_at DESC",:conditions=>['school_id =?',school.id]).paginate :page => params[:page],:per_page => 25
  end


  def show
    @academic_year = AcademicYear.find(params[:id])
  end


  def new
    @academic_year = AcademicYear.new
  end


  def edit
    @academic_year = AcademicYear.find(params[:id])
  end


  def create
     @academic_year = AcademicYear.new(params[:academic_year])
     school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
     @academic_year.school_id = school.id
     respond_to do |format|
      if @academic_year.save
        flash[:notice] = 'Academic year was successfully created.'
        format.html { redirect_to admin_academic_years_path }
        format.xml  { render :xml => @academic_year, :status => :created, :location => @academic_year }
      else
i        format.html { render :action => "new" }
        format.xml  { render :xml => @academic_year.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @academic_year = AcademicYear.find(params[:id])

    respond_to do |format|
      if @academic_year.update_attributes(params[:academic_year])
        flash[:notice] = 'AcademicYear was successfully updated.'
        format.html { redirect_to(admin_academic_years_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @academic_year.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @academic_year = AcademicYear.find(params[:id])
    @academic_year.destroy

    respond_to do |format|
      format.html { redirect_to(admin_academic_years_url) }
      format.xml  { head :ok }
    end
  end
end
