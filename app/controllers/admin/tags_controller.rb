class Admin::TagsController < ApplicationController
  before_filter :check_admin_role
  layout "admin"
  def index
     @search = Tag.search(params[:search])
     @search.user_id = current_user.id
     @search.order ||= "descend_by_updated_at"
     @tags = @search.all.paginate :page => params[:page],:per_page => 25
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  
  def show
    @tag = current_user.tags.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  
  def new
    @tag = current_user.tags.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

 
  def edit
    @tag = current_user.tags.find(params[:id])
  end

 
  def create
    @tag = current_user.tags.new(params[:tag])
    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag is successfully created.'
        format.html { redirect_to admin_tags_path }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

 
  def update
    @tag = current_user.tags.find(params[:id])
    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag is successfully updated.'
        format.html { redirect_to admin_tags_path}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @tag = current_user.tags.find(params[:id])
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
      format.xml  { head :ok }
    end
  end
end
