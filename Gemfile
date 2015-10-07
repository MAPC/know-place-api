source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '4.2.3'
gem 'rails-api'

# Database
gem 'pg'
gem 'pg_search'
gem 'pg_array_parser'

# JSON API
gem 'jsonapi-resources'
# gem 'jsonapi-serializers' # Serialize with JSONAPI.org standard
gem 'kaminari'            # Pagination
gem 'api-pagination'      # Paginates API in headers
gem 'rack-cors', require: 'rack/cors' # CORS Headers

# Auth
gem 'bcrypt' # Security
gem 'warden' # Authentication
gem 'pundit' # Authorization
gem 'activerecord-session_store' # ActiveRecord Sessions (not cookies)


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
  # OSX Notification Center reporter
  # NOTE: Doesn't run in TMUX, and freezes Guard.
  # gem 'minitest-osx', require: RUBY_PLATFORM.include?('darwin') && 'minitest/osx'
end


group :production do
  gem 'puma' # App server
end