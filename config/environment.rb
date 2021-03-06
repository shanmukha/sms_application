# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.6' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
 #require 'configatron'
  #configatron.configure_from_yaml('config.yml')

 Rails::Initializer.run do |config|
   config.gem 'mislav-will_paginate', 
		  :version => '~> 2.3.6', 
		  :lib => 'will_paginate', 
  	          :source => 'http://gems.github.com'
   config.gem 'prawn'
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
   config.gem "authlogic",:lib =>"authlogic",:version =>"2.1.1"
   config.gem "googlecharts",:lib => "gchart.rb",:version => "1.4.0"
   config.gem "searchlogic"
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
   #config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'Mumbai'
  config.action_mailer.delivery_method = :smtp
  #config.action_mailer.perform_deliveries = true 
  #config.action_mailer.raise_delivery_errors = true 

=begin
 config.action_mailer.smtp_settings = {
   :enable_starttls_auto => true,
   :address => "smtp.gmail.com",
   :port => "587",
   #:domain => "qdrllc.com",
   :authentication => :plain,
   :user_name => "support@qdrllc.com",
   :password => "password01"
 }
=end


 config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "shoolit.in",
  :user_name            => "schoolit99@gmail.com",
  :password             => "isiritech99",
  :authentication       => "plain",
  :enable_starttls_auto => true
}


 # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_blog_session',
    :secret      => 'f3f57b71ef9345ffccd0c4e841d8e74bb2e7d2ef692a5303bb455fea0667a62d30458d17f95766b12906aa6c2a3c29d584a55dd18426ffc04610be49956a51af'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end
