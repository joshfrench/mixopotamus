class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Swap.current.register(user) if Swap.current.open?
  end
end
