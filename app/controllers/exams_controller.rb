class ExamsController < ApplicationController
 #before_filter :check_admin_role
 layout "main"
  
  def index
   admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) 
   school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
    @search =  Exam.search(params[:search]) 
    @search.school_id = school.id unless school.nil?
    @search.order ||= "descend_by_created_at"
    @exams = @search.all.paginate :page => params[:page],:per_page => 25
  end


  def show
    @exam = Exam.find(params[:id])
    
  end


  def new
    @exam = Exam.new
  end


  def edit
    @exam = Exam.find(params[:id])
    @classes = @exam.groups.find(:all,:conditions=>['status =?','Active'])
    @exam_subjects = @exam.exam_subjects
  end


  def create
    if check_requried_field_are_present
       @exam = Exam.new(params[:exam])
       admin = current_user.has_role?('admin') ? current_user : User.find(current_user.parent_id) 
       school = School.find(:first,:conditions=>['administrator_id=?',admin.id])
       @exam.school_id=school.id
       if @exam.save
        academic_year = AcademicYear.current_academic_year_school(school.id)
         params[:group_ids].each do |gr_id|
           group = Group.find(gr_id)
           options = { :group_id => group.id, :exam_id => @exam.id, :academic_year_id => academic_year.id }
           ExamClass.create(options)
           
           group.subjects.find(:all).each do |subject|
             options1 = { :maximum_marks => subject.max_marks, :passing_marks => subject.passing_marks , :subject_id => subject.id }
             ExamSubject.create(options1.merge!(options))
           end
           
         end
       end
       flash[:notice] = 'Exam record is successfully created.'
       redirect_to edit_exam_path(@exam)
    else   
      @exam = Exam.new(params[:exam])
      render :action => "new"
    end
  end


  def update
    @exam = Exam.find(params[:id])
    respond_to do |format|
     if @exam.update_attributes(params[:exam])
        @classes = @exam.groups.find(:all,:conditions=>['status =?','Active'])
         @exam.exam_subjects.each do|exam_subject|
         exam_subject.destroy
         end
          school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
        academic_year = AcademicYear.current_academic_year_school(school.id)
        @classes.each do |clas|
        clas.subjects.find(:all).each do|subject|
if params[:class]["#{clas.id}"][:subjects].include?(subject.id.to_s)
        to_time = params[:class]["#{clas.id}"]["#{subject.id}"][:to_time]
        from_time = params[:class]["#{clas.id}"]["#{subject.id}"][:from_time]
        exam_date = params[:class]["#{clas.id}"]["#{subject.id}"][:exam_date] 
        ExamSubject.create(:exam_id => @exam.id,:group_id => clas.id,:subject_id =>subject.id,:academic_year_id => academic_year.id,:maximum_marks => params[:class]["#{clas.id}"]["#{subject.id}"][:max_marks],:passing_marks => params[:class]["#{clas.id}"]["#{subject.id}"][:passing_marks],:exam_date => Time.parse("#{exam_date['exam_date(1i)']}-#{exam_date['exam_date(2i)']}-#{exam_date['exam_date(3i)']}"),:to_time =>Time.parse("#{to_time['to_time(4i)']}:#{to_time['to_time(5i)']}") ,:from_time =>Time.parse("#{from_time['from_time(4i)']}:#{from_time['from_time(5i)']}") ) 
      end
    end
  end
        flash[:notice] = 'Subject was successfully updated.'
        format.html { redirect_to(exam_path(@exam))  }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    redirect_to(exams_url) 
   end

   def groups
      @subjects = Group.find(params[:group_id]).subjects.collect {|s| [s.name,s.id]}
      render :update do |page|
     	page.replace_html 'subjects', :partial => 'group_subjects'
      end
   end 

   def replace_maximum_marks
      @subject = Subject.find(params[:subject_id])
      render :update do |page|
         page.replace_html 'maximum_marks', :partial => 'maximum_marks' 
      end
   end
   private
   
   def check_requried_field_are_present
       flash[:error] = []
       flash[:error] << "Please select atleast one class." if params[:group_ids].blank?
       #flash[:error] << "<br /> Please enter maximum_marks" if params[:exam][:maximum_marks].blank?
       flash[:error] << "<br /> Please enter exam type" if params[:exam][:exam_type].blank?
       value = flash[:error].empty?? true : false  
       flash[:error].empty?? (flash[:error]= nil) : ''
       value
       
   end
end
