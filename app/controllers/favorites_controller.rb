class FavoritesController < ApplicationController
  before_filter :login_required, :get_current_set
  
 def create
    @to = User.find(params[:favorite][:to])
    current_user.favorite(@to, current_user.swapsets.find(params[:favorite][:swapset]))
    render :action => "swap_star"
  end
  
  def destroy
    @to = User.find_by_id current_user.favorites.find_by_id(params[:id]).destroy.to_user
    render :action => "swap_star"
  end
  
  protected
  def get_current_set
    @set = current_user.find_swapset_by_position(1)
  end
  
end