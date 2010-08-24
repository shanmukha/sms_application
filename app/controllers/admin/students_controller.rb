class Admin::StudentsController < ApplicationController
  #layout proc{ |c| ['student_details'].include?(c.action_name)? 'parent' : 'main'}
   layout "admin",:except => [:import_students_new]
  #layout "main",:except => [:import_students_new]
  #layout "parent",:only =>[:student_details]
  before_filter :check_admin_role, :except =>[:index,:show,:student_details,:student_message_show,:student_schedule_show,:student_letter_show,:student_email_show]
  require "csv"

  def index
    admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id)
    @search = Student.search(params[:search])
    @search.user_id = admin.id 
    @search.status = "Active"  if !params[:search]
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
    school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
    academic_year = AcademicYear.current_academic_year_school(school.id)
    @student = admin.students.find(params[:id])
    @emails = @student.emails.find(:all)
    @messages = Student.find_student_messages(@student)
    @letters = @student.letters.find(:all)
    @schedules = @student.schedules.find(:all) 
    from_date = "#{academic_year.from_date} 00:00:00"
    to_date = "#{academic_year.to_date} 23:59:59"   
    @marks = @student.marks.find(:all,:conditions => ['created_at >= ? and created_at <= ?',from_date,to_date]) 
    @exam_names,@percentages = Exam.find_exam_names_and_percentage(@student,academic_year,school)
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
    @student_name = @student.name
     if @student.save
        flash[:notice] = 'Student record is successfully created.'
        format.html { redirect_to(admin_students_url) }
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
     respond_to do |format|
       if @student.update_attributes(params[:student])
        flash[:notice] = 'Student record is successfully updated.'
        format.html { redirect_to(admin_students_url) }
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
      format.html { redirect_to(admin_students_url) }
      format.xml  { head :ok }
    end
  end
  
  def make_active
    student = current_user.students.find(params[:id])
    student.status = "Active"
    student.save
    respond_to do |format|
      flash[:notice] = "#{student.name} is successfully activated."
      format.html { redirect_to(admin_students_url) }
      format.xml  { head :ok }
   end
end
  
  def make_inactive
   student = current_user.students.find(params[:id])
   student.status = "Inactive"
   student.save
   respond_to do |format|
       flash[:notice] = "#{student.name} is successfully inactivated."
       format.html { redirect_to(admin_students_url) }
       end
  end
  
  
  def import_students_new 
  
  end
  
   def student_message_show
      @message =  Message.find(params[:message_id])
      @student =  Student.find(params[:student_id])
   end  
  
  def student_letter_show
    @letter = Letter.find(params[:letter_id])
    @student = Student.find(params[:student_id])
  end
  
  def student_schedule_show
   	@schedule = Schedule.find(params[:schedule_id])
   	@student = Student.find(params[:student_id])
  end
  
  def student_email_show
   	@email = Email.find(params[:email_id])
   	@student = Student.find(params[:student_id])
  end
  
  def import_students_create
  	@parsed_file =  CSV::Reader.parse(params[:students][:file])
    @parsed_file.each do |row|
     	Student.create(:name => row[0],:gender => row[1],:language => row[2],:blood_group => row[3],:dob => row [4],:student_mobile_number => row[5],:student_email => row[6],:admission_number => row[7],:date_of_admission => row[8],:mother => row[9],:mother_mobile => row[10],:father => row[11],:father_mobile => row[12],:guardian => row[13],:guardian_number => row[14],:email => row[15],:address => row[16],:number => row[17],:contact_name => row[18],:user_id => current_user.id) 
    end
     respond_to do |format|
     		flash[:notice] = 'Student record is successfully imported.'
     		format.html { redirect_to(admin_students_url) }
      	format.xml  { head :ok }
    end
    end

  def student_details
    @student = Student.find(params[:student_id])
    @emails = @student.emails.find(:all)
    @messages = Student.find_student_messages(@student)
    @letters = @student.letters.find(:all)
    @schedules = @student.schedules.find(:all)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end


end  
