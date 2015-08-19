source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'rails-api'

# Database
gem 'pg'

# JSON API
gem 'jsonapi-serializers' # Serialize with JSONAPI.org standard
gem 'kaminari'            # Pagination
gem 'api-pagination'      # Paginates API in headers
gem 'rack-cors', require: 'rack/cors' # CORS Headers

# Utilities
gem 'foreman', require: false
gem 'wannabe_bool'        # Convert boolean-ish values to booleans
gem 'httparty'            # HTTP requests

group :development do
  gem 'spring'            # Keeps environment in background
  gem 'better_errors'     # Clearer error messages
  gem 'binding_of_caller' # REPL & more in error page
  gem 'byebug'            # Debugger

  gem 'guard', '>= 2.2.2',       require: false # Autorun tests
  gem 'guard-minitest',          require: false # MiniTest adapter
  gem 'rb-fsevent',              require: false # Mac file system watch
  gem 'terminal-notifier-guard', require: false
end

group :development, :test do
  gem 'minitest-rails'     # Test library
  gem 'minitest-reporters' # For progress bar, etc.
  # From https://mattbrictson.com/minitest-and-rails#set-up-your-project
  # Maybe not needed but good to have the link around
  # gem 'connection_pool'
  # gem 'test_after_commit'
end

group :production do
  gem 'puma' # App server
end

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
