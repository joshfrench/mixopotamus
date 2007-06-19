class FavoriteObserver < ActiveRecord::Observer
  def after_create(favorite)
    favorite.user.confirm favorite.assignment
  end
end
