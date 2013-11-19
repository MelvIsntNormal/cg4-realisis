source 'https://rubygems.org'
ruby '2.0.0' 
# Version required for this application

gem 'rubyzip', '< 1.0.0'
gem 'rails', '4.0.1' 		# Rails framework
gem 'bootstrap-sass', '2.3.2.0' # Used for advanced CSS: open-source Sass add on from Twitter 
gem 'bcrypt-ruby', '3.1.2' 	# Used for password encryption
gem 'pg', '0.15.1'		# Used for connection to Postgres
gem 'jquery-ui-rails' # Used to create user interfaces
gem 'em-websocket', git: 'git://github.com/igrigorik/em-websocket.git'
gem 'crypt'                                       # Used for message encryption
gem 'eventmachine'                    # EM-Websocket dependancy
gem 'gon'                           # Used to pass variables from Rails to Javascript.
gem 'delayed_job_active_record'
gem 'clockwork'

group :assets do
  gem 'haml_coffee_assets' # Used for Coffescript template generation
  gem 'execjs' # Javascript helper
end

group :development, :test do 	# Groups define the environment in which the Gem will be needed
  gem 'rspec-rails', '2.13.1'	# Used for testing/TDD
  gem 'guard-rspec', '2.5.0'	# Used for automated RSpec testing
end

group :test do						# Used within the test environment
  gem 'selenium-webdriver', '2.0.0'			# Used with RSpec to create automated tests
  gem 'capybara', '2.1.0'				# Adds more natural syntax to RSpec test scripts, and allows webpage tests
  gem 'libnotify', '0.8.0'				# Automatic notifications of Guard RSpec test results
  gem 'spork-rails'       # Used to speed up testing
  gem 'guard-spork', '1.5.0'				# Required for Guard/Spork compatibility: autostarts a Spork server with Guard
  gem 'childprocess', '0.3.6'				# Controls external programs
  gem 'factory_girl_rails', '4.2.1'			# Used mainly for testing Model management
end

gem 'sass-rails', '4.0.0'	# Advanced CSS styling
gem 'uglifier', '2.1.1'		# minifies Javascript code
gem 'coffee-rails', '4.0.0'	# Allows CoffeeScript to adapt to the Assets pipeline
gem 'coffee-script-source', '1.5.0'
gem 'jquery-rails', '2.2.1'	# Advanced Javascript functions: added ease of use
gem 'turbolinks', '1.1.1'	# Makes following links faster: uses Assets pipeline
gem 'jbuilder', '1.0.2'		# Creates JSON structures

group :doc do			# required gem
  gem 'sdoc', '0.3.20', require: false
end

group :production do		# used only within deployment
  gem 'rails_12factor', '0.0.2'
end
