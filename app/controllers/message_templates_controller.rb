class MessageTemplatesController < ApplicationController
  layout "admin", :except => "show"
 	
 	def index
  	@search = MessageTemplate.search(params[:search])
    @search.user_id = current_user.id if current_user.has_role?('teacher') || current_user.has_role?('super_admin')
    @search.user_id = user_ids if current_user.has_role?('admin') && !current_user.has_role?('super_admin')
    @search.order ||= "descend_by_created_at"
    @message_templates = @search.all.paginate :page => params[:page],:per_page => 25
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @message_templates }
    end
  end
 
  def show
    @message_template = MessageTemplate.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message_template }
    end
  end

  def new
    @message_template = MessageTemplate.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message_template }
    end
  end

  def edit
    @message_template = MessageTemplate.find(params[:id])
  end

  def create
    @message_template = current_user.message_templates.new(params[:message_template])
    respond_to do |format|
      if @message_template.save
        flash[:notice] = 'MessageTemplate was successfully created.'
        format.html { redirect_to(message_templates_url) }
        format.xml  { render :xml => @message_template, :status => :created, :location => @message_template }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message_template.errors, :status => :unprocessable_entity }
      end
    end
  end
 
	def update
    @message_template = MessageTemplate.find(params[:id])
    respond_to do |format|
      if @message_template.update_attributes(params[:message_template])
        flash[:notice] = 'MessageTemplate was successfully updated.'
         format.html { redirect_to(message_templates_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message_template.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def destroy
    @message_template = MessageTemplate.find(params[:id])
    @message_template.destroy
    respond_to do |format|
      format.html { redirect_to(message_templates_url) }
      format.xml  { head :ok }
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
