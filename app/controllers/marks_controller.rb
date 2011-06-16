class MarksController < ApplicationController
  layout "main"
  #before_filter :check_teacher_role,:except =>[:index,:show]

  def index
    @marks = Mark.all
#Mark.find(:all, :include => [:schools,:group,:student],:conditions => ['schools.id=?' , 1])
  end


  def show
    @mark = Mark.find(params[:id])
  end


  def new
    @mark = Mark.new
    @exam = Exam.find(params[:exam_id])
    @group = Group.find(params[:group_id])
    @students = @group.students.find(:all)
  end


  def edit
    @mark = Mark.find(:first)
    @exam = Exam.find(params[:exam_id])
    @group = Group.find(params[:group_id])
    @students = @group.students.find(:all,:conditions =>['status =?','Active'])
  end


  def create
      exam = Exam.find(params[:exam_id])
      group = Group.find(params[:group_id])
      group.students.find(:all,:conditions =>['status =?','Active']).each do|student|
      	exam.subjects.find(:all).each do|subject|
        Mark.create(:student_id => student.id,:exam_id =>exam.id,:group_id =>group.id,:subject_id =>subject.id,:mark => params[:marks]["#{student.id}"]["#{subject.id}"][:mark])
   end
   end
      flash[:notice] = 'Mark was successfully created.'
      redirect_to exam_path(exam.id)
   end


  def update
    @mark = Mark.find(params[:id])
     exam = Exam.find(params[:exam_id])
     group = Group.find(params[:group_id])
     exam.marks.each do|mark|
     mark.destroy
     end
    respond_to do |format|
      group.students.find(:all,:conditions =>['status =?','Active']).each do|student|
      	exam.subjects.find(:all).each do|subject|
        Mark.create(:student_id => student.id,:exam_id =>exam.id,:group_id =>group.id,:subject_id =>subject.id,:mark => params[:marks]["#{student.id}"]["#{subject.id}"][:mark])
   end
   end
        flash[:notice] = 'Mark was successfully updated.'
        format.html { redirect_to exam_path(exam.id) }
        format.xml  { head :ok }
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
   def mark_individual_subject
     @exam = Exam.find(params[:exam_id])
     @group = Group.find(params[:group_id])
     @subject = Subject.find(params[:id])
  end
   def create_mark_individual_subject
      @exam = Exam.find(params[:exam_id])
     @group = Group.find(params[:group_id])
     @subject = Subject.find(params[:subject_id])
        @group.students.find(:all,:conditions =>['status =?','Active']).each do|student|
      	Mark.create(:student_id => student.id,:exam_id =>@exam.id,:group_id =>@group.id,:subject_id =>@subject.id,:mark => params[:marks]["#{student.id}"]["#{@subject.id}"][:mark])
   end
   flash[:notice] = 'Mark was successfully created.'
    redirect_to exam_path(@exam.id)
  end
  def edit_mark_individual_subject
    @exam = Exam.find(params[:exam_id])
    @group = Group.find(params[:group_id])
    @subject = Subject.find(params[:id])
    @students = @group.students.find(:all,:conditions =>['status =?','Active'])
 end
  def update_mark_individual_subject
   @exam = Exam.find(params[:exam_id])
    @group = Group.find(params[:group_id])
    @subject = Subject.find(params[:id])
    @group.students.find(:all,:conditions =>['status =?','Active']).each do|student|
     get_marks(@exam,@group,@subject,student).each do|mark|
      mark.destroy
    end
     Mark.create(:student_id => student.id,:exam_id =>@exam.id,:group_id =>@group.id,:subject_id =>@subject.id,:mark => params[:marks]["#{student.id}"]["#{@subject.id}"][:mark])
   end
   flash[:notice] = 'Mark was successfully created.'
    redirect_to exam_path(@exam.id)
  end
    private
  def get_marks(exam,group,subject,student)
     Mark.find(:all,:conditions => ['exam_id =? and group_id =? and subject_id =? and student_id =?',exam.id,group.id,subject.id,student.id])
 end
end
