class UsersController < ApplicationController
  layout "admin"
  before_filter :check_logged_in,:except =>"forgot_password"
 	before_filter "check_role('super_admin','admin')",:except =>[:edit,:update,:forgot_password] 
 
   def new
    @user = User.new
   end
  	
  	def index
      @search = User.search(params[:search])
      @search.parent_id = current_user.id
      @search.order ||= "descend_by_updated_at"
      @users = @search.all.paginate :page => params[:page],:per_page => 25
   	 respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @clients }
    end
   end
  
  def create
    @user = User.new(params[:user])
    if @user.save
       if current_user.has_role?('super_admin')
         @user.update_attribute('parent_id',1)
         admin_role = Role.find(:first,:conditions =>['name = ?','admin'])
         @user.roles<< admin_role
       elsif current_user.has_role?('admin') && !current_user.has_role?('super_admin')
          @user.update_attribute('parent_id',current_user.id)
          teacher_role = Role.find(:first,:conditions =>['name = ?','teacher'])
          @user.roles<< teacher_role
       end   
       flash[:notice] = "Registration successful."
       redirect_to users_path
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
      redirect_to user_path(@user)  if current_user.has_role?('super_admin') || current_user.has_role?('admin')
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
         flash[:notice] = "New password sent to your mail id."
          @user_session = UserSession.find
          @user_session.destroy
         end
         else
         # Render forgot_password.html.erb
       end
        render :layout =>"main" 
    end
   
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
