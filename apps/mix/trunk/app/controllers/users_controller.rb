class UsersController < ApplicationController
  before_filter :login_required, :get_user
  
  def show
    @user = current_user
  end
  
  def update
    respond_to do |format|
      format.js do
        flash.now[:confirm] = "Changes saved." if @user.update_attributes(params[:user])
      end
    end
  end
  
  def stats
    render :layout => false
  end
  
  protected
  def get_user
    @user = current_user
  end
  
  def authorized?
    %w{ update }.include?(action_name) ? current_user == User.find(params[:id]) : true
  end
  
end
