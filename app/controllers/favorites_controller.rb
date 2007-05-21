class FavoritesController < ApplicationController
  before_filter :login_required
  
 def create
    @to = User.find(params[:favorite][:to])
    @set = current_user.find_swapset_by_position(1)
    current_user.favorite(@to, current_user.swapsets.find(params[:favorite][:swapset]))
  end
  
end