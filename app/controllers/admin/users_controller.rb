class Admin::UsersController < ApplicationController
  layout "admin"
  before_filter :check_logged_in,:except =>"forgot_password"
 	before_filter "check_role('super_admin','admin')",:except =>[:edit,:update,:forgot_password] 
 
   def new
    @user = User.new
   end
  	
   def index
     @school = School.find(:first,:conditions=>['administrator_id=?',current_user.id])
      @search = User.search(params[:search])
     if params[:role] == "teacher"
      @search.school_id = params[:school_id]
     else
      @search.parent_id = current_user.id
      end
      @search.order ||= "descend_by_updated_at"
      @users = @search.all.paginate :page => params[:page],:per_page => 25
   	 respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @clients }
    end
   end
  
  def create
    @user = User.new(params[:user])
    unless params[:school_id].blank?
      @user.school_id = params[:school_id]
    end
    if @user.save
       teacher_role = Role.find(:first,:conditions =>['name = ?','teacher'])
       if params[:role] == "teacher"
          @user.roles << teacher_role
       end
       if current_user.has_role?('super_admin')
         @user.update_attribute('parent_id',1)
         admin_role = Role.find(:first,:conditions =>['name = ?','admin'])
         @user.roles<< admin_role
        User.set_default_template_tag(current_user,@user) #copying message template and tag from super admin to admin.#
       elsif current_user.has_role?('admin') && !current_user.has_role?('super_admin')
          @user.update_attribute('parent_id',current_user.id)
          teacher_role = Role.find(:first,:conditions =>['name = ?','teacher'])
          @user.roles<< teacher_role
       end   
       flash[:notice] = "Registration successful."
       redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end
  
   def show 
     @user = User.find(params[:id])
   end
  
   def edit
     if current_user.has_role?('super_admin') || current_user.has_role?('admin')
      @user = User.find(params[:id]) 
     else
       @user = User.find(current_user.id)
     end  
   end
  
  def update
    if current_user.has_role?('super_admin')|| current_user.has_role?('admin')
     @user = User.find(params[:id])
    else
      @user = User.find(current_user.id)
    end  
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated profile."
      redirect_to admin_user_path(@user)  if current_user.has_role?('super_admin') || current_user.has_role?('admin')
      redirect_to root_path  if current_user.has_role?('teacher')
    else
      render :action => 'edit'
    end
  end
   
   def forgot_password
     if request.put?
      @user = User.find_by_username_or_mail_id(params[:email_or_login])
     if @user.nil?
        flash.now[:error] = 'No account was found by that login or email address.'
      else
        @user.forgot_password 
        @user_session = UserSession.find
        @user_session.destroy
      end
         else
       end
        render :layout =>"login" 
    end
   
      
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
  end
end
