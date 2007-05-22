ActionController::Routing::Routes.draw do |map|
  map.resources :swapsets, :swaps
  map.resources :users do |user|
    user.resources :invites, :member => {:confirm => :post}
    user.resources :registrations, :favorites, :confirmations
  end
  
  map.resources :invites, :name_prefix => "redeem_"
  
  map.login 'login', :controller => 'account', :action => 'login'
  map.logout 'logout', :controller => 'account', :action => 'logout'
  map.signup 'register', :controller => 'account', :action => 'signup'
  
  # Install the default route as the lowest priority.
  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller/:action/:id'
  map.default '/', :controller => 'account', :action => 'show'
end
