class UsersController < ApplicationController
  before_filter :login_required, :get_user
  
  def show
    @user = current_user
  end
  
  def update
    respond_to do |format|
      format.js do
        if @user.update_attributes(params[:user])
          flash.now[:confirm] = "Changes saved."
        else
          render :action => :update
        end
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
  
end
