source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '4.2.5.1'
gem 'rails-api', require: false

# Database
gem 'pg'
gem 'pg_search'
gem 'pg_array_parser'

# JSON API
gem 'jsonapi-resources'   # Implements JSONAPI.org Spec
gem 'versionist'          # Versioning API
gem 'kaminari'            # Pagination
gem 'api-pagination'      # Paginates API in headers
gem 'rack-cors', require: 'rack/cors' # CORS Headers

# Auth
gem 'bcrypt' # Security
gem 'devise' # Authentication
gem 'pundit' # Authorization / Access Control
gem 'activerecord-session_store' # ActiveRecord Sessions (not cookies)

# Admin console
gem 'administrate'
gem 'bourbon'
gem 'semantic-ui-sass', github: 'doabit/semantic-ui-sass'

# Utilities
gem 'foreman',      require: false
gem 'wannabe_bool'        # Convert boolean-ish values to booleans
gem 'httparty'            # HTTP requests

group :development do
  gem 'spring'            # Keeps environment in background
  gem 'better_errors'     # Clearer error messages
  gem 'binding_of_caller' # REPL & more in error page
  gem 'byebug'            # Debugger

  gem 'guard', '>= 2.2.2',       require: false # Autorun tests
  gem 'guard-minitest',          require: false # MiniTest adapter
  # Watch Mac filesystem events
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end

group :development, :test do
  # From https://mattbrictson.com/minitest-and-rails#set-up-your-project
  # Maybe not needed but good to have the link around
  # gem 'connection_pool'
  # gem 'test_after_commit'
end

group :test do
  gem 'rake' # Comes default, but specifying for Travis CI
  gem 'codeclimate-test-reporter', require: nil

  gem 'minitest-rails'     # Test library
  gem 'minitest-reporters' # For progress bar, etc.
  gem 'minitest-focus'
end


group :production do
  gem 'puma'      # App server
  gem 'scout_apm' # Track responses and memory bloat
end
