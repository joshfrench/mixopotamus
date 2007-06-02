# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store


  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :invite_observer, :confirmation_observer, :assignment_observer


end

ActionMailer::Base.smtp_settings = {
  :authentication => :login,
  :address => "mail.dawdlebot.com",
  :port => 25,
  :domain => "dawdlebot.com",
  :user => "shirker",
  :password => "g0b0ts"
}


require 'action_mailer/ar_mailer'
require 'uuidtools'
require 'permutation'

SWAP_LENGTH = 13.weeks
SWAPSET_SIZE = 6
ADMIN_EMAIL = 'josh@vitamin-j.com'
PROJECT_NAME = 'UNNAMED MIX PROJECT'
ExceptionNotifier.exception_recipients = %w(josh@vitamin-j.com)

Time::DATE_FORMATS[:small] = "%B %d"
Time::DATE_FORMATS[:micro] = "%B %Y"