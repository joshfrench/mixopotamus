ActionController::Routing::Routes.draw do |map|
  map.resources :invites

  map.resources :favorites

  map.resources :swapsets

  map.resources :swaps


  map.resources :account
  
  map.login 'login', :controller => 'account', :action => 'login'
  map.logout 'logout', :controller => 'account', :action => 'logout'
  map.signup 'register', :controller => 'account', :action => 'signup'
  
  # Install the default route as the lowest priority.
  # map.connect ':controller/:action/:id.:format'
  # map.connect ':controller/:action/:id'
end
