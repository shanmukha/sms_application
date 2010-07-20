class ExamsController < ApplicationController
 #before_filter :check_admin_role
 #layout "admin"
 layout "main"
  
  def index
    @exams = Exam.all
  end


  def show
    @exam = Exam.find(params[:id], :include => [:groups])
  end


  def new
    @exam = Exam.new
  end


  def edit
    @exam = Exam.find(params[:id])
  end


  def create
    if check_requried_field_are_present
       @exam = Exam.new(params[:exam])
       if @exam.save
         academic_year = AcademicYear.current_academic_year_school(current_user.school_id)
         params[:group_ids].each do |gr_id|
           group = Group.find(gr_id)
           options = { :group_id => group.id, :exam_id => @exam.id, :academic_year_id => academic_year.id }
           ExamClass.create(options)
           
           group.subjects.each do |subject|
             options1 = { :maximum_marks => subject.max_marks, :passing_marks => subject.passing_marks , :subject_id => subject.id }
             ExamSubject.create(options1.merge!(options))
           end
           
         end
       end
       redirect_to exam_path(@exam)
    else   
      @exam = Exam.new(params[:exam])
      render :action => "new"
    end
  end


  def update
    @exam = Exam.find(params[:id])
    respond_to do |format|
      if @exam.update_attributes(params[:exam])
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
       flash[:error].empty?? true : false  
       
   end
end
