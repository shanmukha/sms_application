class EmailsController < ApplicationController
 layout proc{ |c| ['show_email'].include?(c.action_name)? 'parent' : 'main'}
  
  def index
    @search =  Email.search(params[:search]) 
    @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('admin')
    @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('admin')
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
       if params[:students].blank?
          flash.now[:error] = "Please select at least one student"
          render :action => "new"
       return nil
    end
     @email = current_user.emails.new(params[:email])  
    respond_to do |format|
     if  @email.save
      	  body = params[:email][:body]
          params[:students].each do  |student_id|
        	student = Student.find(student_id)
          body.gsub!(/@student/, student.name) 
       	  body.gsub!(/@parent/, student.parent)
       	  body.gsub!(/@address/, student.address)
       	  body.gsub!(/@Student/, student.name) 
       	  body.gsub!(/@Parent/, student.parent)
       	  body.gsub!(/@Address/, student.address)
          EmailStudent.create(:email_id => @email.id,:student_id => student_id)
          Notifier.deliver_email_notification(@email,current_user,student)
          body.gsub!(/#{student.name}/,'@student') 
        	body.gsub!(/#{student.parent}/,'@parent') 
        	body.gsub!(/#{student.address}/,'@address') 
        end 
        flash[:notice] = 'Email is successfully sent.'
        format.html { redirect_to(emails_url)  }
        format.xml  { render :xml => @email, :status => :created, :location => @email }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
       end
     end
     rescue 
      flash.now[:error] = 'There seems to be some problem in sending email. Please try later.'    
      render :action => "new"
      return nil
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
  @students = Group.find(params[:group_id]).students.find(:all, :order => 'students.name ASC',:conditions =>['status =?','Active']) rescue ''
      render :update do |page|
      page.replace_html 'students', :partial => 'group_student'
   end
  end 
  
  def show_email
     @email = Email.find(params[:id])
  end

  private
   def user_ids
      user_ids  = []
      user_ids << current_user.id
      User.find(:all,:conditions =>['parent_id = ?',current_user.id]).map{|object|user_ids << object.id}
     return user_ids
  end
end
