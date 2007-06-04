class FavoritesController < ApplicationController
  before_filter :login_required, :get_current_set
  
 def create
   @current_user = User.find(params[:user_id])
   respond_to do |format|
    format.js do
      assignment = Assignment.find(params[:assign])
      @user = assignment.user
      @current_user.favorite(@user, assignment.swapset)
      render :action => "swap_star"
    end
   end
  end
  
  def destroy
    respond_to do |format|
      format.js do
        @user = User.find(params[:user_id])
        @user.favorites.find_by_id(params[:id]).destroy.user_id
        render :action => "swap_star" 
      end
    end
  end
  
  def authorized?
    current_user == User.find(params[:user_id])
  end
  
end