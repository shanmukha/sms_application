class Admin::StudentClassesController < ApplicationController
before_filter :check_admin_role
 layout "admin"
 def index
  @group = Group.find(params[:group_id])
  @students = @group.students.find(:all)
end

def new
  @group = Group.find(params[:id])
  @students = current_user.students.find(:all,:conditions =>['status =?','Active'])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
 end
end
 def create
  #@group = current_user.groups.new(params[:student_class])
   @group = Group.find(params[:id]) 
   students = params[:students]
    respond_to do |format|
      school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
      #@group.school_id = school.id
      academic_year = AcademicYear.current_academic_year_school(school.id)
     # if @group.save
      	unless students.blank?
          students.each do  |student|
          StudentClass.create(:student_id => student,:group_id => @group.id,:academic_year_id => academic_year.id)
         end
      end
       Group.copy_students_from_group(params[:group_id],@group,current_user) unless params[:group_id].blank?
       flash[:notice] = "#{@group.name} record is successfully created."
       format.html { redirect_to(admin_group_student_classes_url(@group.id)) }
       format.xml  { render :xml => @group, :status => :created, :location => @group }
     end
   end
 
  def edit
    @group,@group_students,@non_group_students = Group.find_group_all_students(params[:id],current_user)
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
        format.html { redirect_to(admin_group_student_classes_url(@group.id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end
 end
