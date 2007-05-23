class SiteController < ApplicationController
  
  layout 'application', :except => [ :sidebar, :stats ]
  
end
