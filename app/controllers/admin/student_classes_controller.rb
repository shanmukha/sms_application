class Admin::StudentClassesController < ApplicationController
before_filter :check_admin_role
 layout "admin"
 def index
  @group = Group.find(params[:group_id])
  @students = @group.students.find(:all,:conditions =>['status =?','Active'])
end

def new
  @group = Group.find(params[:group_id])
   @search =  Student.search(params[:search]) 
   @search.user_id = current_user.id
   @search.status = 'Active'
   @students = @search.all
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
       admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) 
       @school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
       @subjects = Subject.find(:all,:conditions => ['school_id =?',@school.id])
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

 def promote_students
   unless params[:class_id].blank? 
     @group = Group.find(params[:group_id])
     StudentClass.delete_all(["group_id = ?", params[:group_id]])
     Group.copy_students_from_group(params[:class_id],@group,current_user) 
     flash[:notice] = "Students are successfully promoted."
     redirect_to(admin_group_student_classes_url(params[:group_id])) 
    else
     redirect_to(admin_group_student_classes_url(params[:group_id])) 
   end
 end
end
