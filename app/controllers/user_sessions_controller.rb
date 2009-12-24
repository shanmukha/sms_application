class UserSessionsController < ApplicationController
   layout "login"
    skip_before_filter :check_logged_in 
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      flash.now[:error] = "Invalid username and/or password. Please try again"
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to new_user_session_path
   end
end
