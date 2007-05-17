# YourController < REST::RestController and you get the basic 7 rest actions.
#
# If you need to do custom initialization then do so, and then just call super.  Since all the instance variables
# are ||='ed it won't override - for instance, if you want to set a custom @page_title.
#
# You can pass options[:template] to your super call to use a custom template (such as having multipl show actions that use
# different templates).  This is also used for the error case on update and create.
#
# Index accepts options[:find_options] so you can do custom ordering.
#
# See the wiki for more details: http://code.google.com/p/restcontroller/w/list

class RestController < ApplicationController
  
  def index(options = {})
    @page_title ||= 'Listing ' + resources_display_name
    resources_instance_set resource_model.find(:all, options[:find_options])
    
    respond_to do |format|
      format.html { render :action => options[:template] || 'index'}
      format.xml  { render :xml => resources_instance.to_xml }
    end
  end
  
  def show(options = {})
    @page_title ||= 'Viewing ' + resource_display_name
    resource_instance_from_id
    
    respond_to do |format|
      if resource_instance
        format.html { render :action => options[:template] || 'show'}
        format.xml  { render :xml => resource_instance.to_xml }
      else
        format.html { render :text => "404: #{resource_display_name} not found", :status => "404" }
      end
    end
  end
  
  def new(options = {})
    @page_title ||= 'Creating ' + resource_display_name
    resource_instance_set resource_model.new
    
    render :action => options[:template] || 'edit'
  end
  
  def edit(options = {})
    @page_title ||= 'Editing ' + resource_display_name
    resource_instance_from_id
    if resource_instance
      render :action => options[:template] || 'edit'
    else
      flash[:notice] = "Invalid ID"
      redirect_to resources_path
    end
  end
  
  def create(options = {})
    resource_instance_set resource_model.create(params_hash)
    
    respond_to do |format|
      if resource_instance.save
        flash[:notice] = resource_display_name + ' created.'
        format.html { redirect_to resources_path }
        format.xml {head :created, :location => resource_path}
      else
        @page_title ||= 'Creating ' + resource_display_name
        format.html { render :action => options[:template] || "edit" }
        format.xml  { render :xml => resource_instance.errors.to_xml }
      end
    end
  end
  
  def update(options = {})
    resource_instance_from_id
    
    respond_to do |format|
      if resource_instance.update_attributes(params_hash)
        flash[:notice] = resource_display_name + ' updated.'
        format.html { redirect_to resources_path}
        format.xml  { render :nothing => true }
      else
        @page_title ||= 'Editing ' + resource_display_name
        format.html { render :action => options[:template] || "edit" }
        format.xml  { render :xml => resource_instance.errors.to_xml }        
      end
    end
  end
  
  def destroy(options = {})
    resource_instance_from_id

    respond_to do |format|
      if resource_instance.destroy
        flash[:notice] = resource_display_name + ' deleted.'
        format.html { redirect_to resources_path   }
        format.xml  { render :nothing => true }
      else
        #TODO: Figure out how to pass error_messages_for so you can redirect http://www.railsweenie.com/forums/8/topics/1177?page=1
        format.html { render :action => options[:template] || "index" }
        format.xml  { render :xml => resource_instance.errors.to_xml }
      end
    end
  end
  
  
  private
  def resource_model
    Object.const_get resource_name.classify
  end
  
  def resource_name
    controller_name.singularize.downcase
  end

  def resources_name
    controller_name.downcase
  end
  
  def resource_display_name
    resource_name.titleize
  end
  
  def resources_display_name
    resource_display_name.pluralize
  end
  
  def resource_instance
    instance_variable_get '@' + resource_name
  end
  
  def resource_instance_set(value)
    instance_variable_set '@' + resource_name, value unless resource_instance
  end
  
  def resource_instance_from_id
    instance_variable_set '@' + resource_name, resource_model.find_by_id(params[:id]) unless resource_instance
  end
  
  def resources_instance
    instance_variable_get '@' + resources_name
  end

  def resources_instance_set(value)
    instance_variable_set '@' + resources_name, value unless resources_instance
  end
  
  def resource_path
    eval("#{resource_name}_path(#{resource_instance})")
  end
  
  def resources_path
    eval("#{resources_name}_path")
  end

  def params_hash
    params[resource_name.to_sym]
  end
end