class MarksController < ApplicationController
  layout "main"
  before_filter :check_teacher_role,:except =>[:index,:show]

  def index
    @marks = Mark.all
#Mark.find(:all, :include => [:schools,:group,:student],:conditions => ['schools.id=?' , 1])
  end


  def show
    @mark = Mark.find(params[:id])
  end


  def new
    @mark = Mark.new
  end


  def edit
    @mark = Mark.find(params[:id])
  end


  def create
    unless params[:student_id].blank?
      @student = Student.find(params[:student_id])
      params[:marks].each do |mark|
         Mark.create(:student_id => @student.id,:exam_id => params[:mark][:exam_id],:subject_id => mark[0],:mark => mark[1])
      end
      flash[:notice] = 'Mark was successfully created.'
      redirect_to marks_path
    else
      flash[:notice] = 'Select Student.'
      render :action => "new"
    end
   end


  def update
    @mark = Mark.find(params[:id])

    respond_to do |format|
      if @mark.update_attributes(params[:mark])
        flash[:notice] = 'Mark was successfully updated.'
        format.html { redirect_to(marks_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mark.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @mark = Mark.find(params[:id])
    @mark.destroy
    redirect_to(marks_url)
  end

  def group_exams
   unless params[:group_id].blank?
     @exams = Exam.find(:all,:conditions =>['group_id =?',params[:group_id]]).collect {|e| [e.exam_type,e.id]} 
     group = Group.find(params[:group_id])
     @students = group.students
     @subjects = group.subjects
   end
     render :update do |page|
        page.replace_html 'exams', :partial => 'group_exams'
     end
   end 

end
