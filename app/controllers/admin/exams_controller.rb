class Admin::ExamsController < ApplicationController
 before_filter :check_admin_role
 layout "admin"
  
  def index
    @exams = Exam.all
  end


  def show
    @exam = Exam.find(params[:id])
  end


  def new
    @exam = Exam.new
  end


  def edit
    @exam = Exam.find(params[:id])
  end


  def create
    @exam = Exam.new(params[:exam])
      respond_to do |format|
      if @exam.save
        flash[:notice] = 'Exam was successfully created.'
        format.html { redirect_to admin_exams_path }
        format.xml  { render :xml => @exam, :status => :created, :location => @exam }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @exam.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @exam = Exam.find(params[:id])
    respond_to do |format|
      if @exam.update_attributes(params[:exam])
        flash[:notice] = 'Subject was successfully updated.'
        format.html { redirect_to(admin_exam_path(@exam))  }
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
    redirect_to(admin_exams_url) 
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
end
