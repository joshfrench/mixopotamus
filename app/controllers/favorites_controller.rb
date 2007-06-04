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
        favorite = User.find(params[:user_id]).favorites.find(params[:id])
        @user = favorite.to_user
        favorite.destroy
        render :action => "swap_star" 
      end
    end
  end
  
  def authorized?
    current_user == User.find(params[:user_id])
  end
  
end