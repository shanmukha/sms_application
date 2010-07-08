class LettersController < ApplicationController
 layout proc{ |c| ['show_letter'].include?(c.action_name)? 'parent' : 'main'}

   def index
  	@search =  Letter.search(params[:search]) 
    @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('admin')
    @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('admin')
    @search.order ||= "descend_by_created_at"
    @letters = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end
	
	def show
    @letter = Letter.find(params[:id])
    @students = @letter.students.find(:all)
    respond_to do |format|
    	format.html # new.html.erb
    	format.xml  { render :xml => @letter }
    end
  end

 def print
    @letter = Letter.find(params[:id])
    @students = @letter.students.find(:all)
    respond_to do |format|
    format.pdf  {
       options = { :left_margin => 50, :right_margin => 30, :top_margin => 60, :bottom_margin => 40, :page_size => 'A4'}
       prawnto :inline => false, :prawn => options, :filename => "#{@letter.reference}.pdf"
       render :layout => false}
      end
  end     
  
  def new
    @letter = Letter.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @letter }
    end
  end
	
  def create
     if params[:students].blank?
      flash.now[:error] = "Please select at least one student"
      render :action => "new" 
      return nil
    end
     @letter = current_user.letters.new(params[:letter]) 
    respond_to do |format|
      if @letter.save
           params[:students].each do|student_id|
           LetterStudent.create(:letter_id => @letter.id,:student_id => student_id)
           end
          flash[:notice] = 'Letter is successfully created.'
          format.html { redirect_to(print_letter_path(@letter)) }
           format.xml  { render :xml => @letter, :status => :created, :location => @letter }
      else
           format.html { render :action => "new" }
           format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end
	
  def show_letter
      @letter = Letter.find(params[:id])
  end

 def destroy
    @letter = Letter.find(params[:id])
    @letter.destroy
    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
  
   def group_students
      @students = Group.find(params[:group_id]).students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active']) rescue ''
      render :update do |page|
     	page.replace_html 'students', :partial => 'group_student'
      end
  end 
  
  def print_labels
    letter = Letter.find(params[:id])
    @students = letter.students.find(:all)
    unless @students.blank?
      options = { :left_margin => 0, :right_margin => 0, :top_margin => 0, :bottom_margin => 0, :page_size => [595, 770] }
      prawnto :inline => false, :prawn => options, :page_orientation => :portrait, :filename => 'labels.pdf'
      render :layout => false  
    end
 end
  
 private
   def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
end
