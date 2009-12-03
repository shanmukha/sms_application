class EmailsController < ApplicationController
  layout "main"
  
  def index
  	@search =  Email.search(params[:search]) 
    @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('super_admin')
    @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
    @search.order ||= "descend_by_created_at"
    @emails = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emails }
    end
  end
  
  def show
  	@email = Email.find(params[:id])
    @students = @email.students.find(:all)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email }
    end
  end
  
  def new
    @email = Email.new
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @email }
    end
  end

  def create
  	@email = current_user.emails.new(params[:email]) if params[:students]
    respond_to do |format|
    	if @email.save
      	body = params[:email][:body]
        params[:students].each do  |student_id|
        	student = Student.find(student_id)
          body.gsub!(/@student/, student.name) 
       	  body.gsub!(/@parent/, student.parent)
       	  body.gsub!(/@address/, student.address)
          EmailStudent.create(:email_id => @email.id,:student_id => student_id)
          Notifier.deliver_email_notification(@email,current_user,student)
          body.gsub!(/#{student.name}/,'@student') 
        	body.gsub!(/#{student.parent}/,'@parent') 
        	body.gsub!(/#{student.address}/,'@address') 
        end 
        flash[:notice] = 'Email was successfully sent.'
        format.html { redirect_to(emails_url)  }
        format.xml  { render :xml => @email, :status => :created, :location => @email }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
       end
     end
      rescue #ActiveResource::ResourceInvalid => e  
       flash[:error] = 'Some thing went wrong. Please try again latter.'    
       redirect_to(emails_url)
  end
 
  def destroy
    @email = Email.find(params[:id])
    @email.destroy
    respond_to do |format|
      format.html { redirect_to(emails_url) }
      format.xml  { head :ok }
    end
  end
    
	def group_students
      @students = Group.find(params[:group_id]).students rescue ''
      render :update do |page|
     		page.replace_html 'students', :partial => 'group_student'
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
