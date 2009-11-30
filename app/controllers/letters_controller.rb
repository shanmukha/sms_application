class LettersController < ApplicationController
 layout "main"
	
	def index
  	@search =  Letter.search(params[:search]) 
    @search.user_id = current_user.id
    @search.order ||= "descend_by_created_at"
    @letters = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @letters }
    end
  end
	
	def show
    @letter = current_user.letters.find(params[:id])
    @students = @letter.students.find(:all)
    respond_to do |format|
    	format.html # new.html.erb
    	format.xml  { render :xml => @letter }
    end
  end

 def print
    @letter = current_user.letters.find(params[:id])
    @students = @letter.students.find(:all)
    respond_to do |format|
    format.pdf  {
       options = { :left_margin => 30, :right_margin => 30, :top_margin => 10, :bottom_margin => 5}
       prawnto :inline => true, :prawn => options, :filename => 'school.pdf'
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
	
	def edit
    @letter = current_user.letters.find(params[:id])
  end
	
	def create
    @letter = current_user.letters.new(params[:letter]) if params[:students]
    respond_to do |format|
      if @letter.save
           params[:students].each do|student_id|
           LetterStudent.create(:letter_id => @letter.id,:student_id => student_id)
           end
          flash[:notice] = 'Letter was successfully created.'
          format.html { redirect_to(print_letter_path(@letter)) }
           format.xml  { render :xml => @letter, :status => :created, :location => @letter }
      else
           format.html { render :action => "new" }
           format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
     rescue #ActiveResource::ResourceInvalid => e  
       flash[:error] = 'Some thing went wrong. Please try again latter.'    
       redirect_to(letters_url)
  end
	
	def update
    @letter = current_user.letters.find(params[:id])
    respond_to do |format|
      if @letter.update_attributes(params[:letter])
        flash[:notice] = 'Letter was successfully updated.'
        format.html { redirect_to(@letter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @letter.errors, :status => :unprocessable_entity }
      end
    end
  end

 def destroy
    @letter = current_user.letters.find(params[:id])
    @letter.destroy
    respond_to do |format|
      format.html { redirect_to(letters_url) }
      format.xml  { head :ok }
    end
  end
  
   def group_students
      @students = Group.find(params[:group_id]).students rescue ''
      render :update do |page|
     	page.replace_html 'students', :partial => 'group_student'
   end
  end 
end
