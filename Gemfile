source 'https://rubygems.org'

gem 'rails', '4.2.3'
gem 'rails-api'

# Database
gem 'pg'
# Parse SQL to validate operation. This is an expensive method and
# might get weird when deploying, so we could also send deferred-
# execution queries to Postgres itself to validate.
#    Basically, this is the quick-and-dirty way.
gem 'pg_query'

# JSON API
gem 'jsonapi-serializers' # Serialize with JSONAPI.org standard
gem 'kaminari'            # Pagination
gem 'api-pagination'      # Paginates API in headers
gem 'rack-cors', require: 'rack/cors' # CORS Headers

# Utilities
gem 'rgeo-geojson', require: 'rgeo/geo_json' # GeoJSON parsing
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
  # Watch Mac filesystem events
  gem 'rb-fsevent', require: RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
end

group :development, :test do
  gem 'minitest-rails'     # Test library
  gem 'minitest-reporters' # For progress bar, etc.
  # OSX Notification Center reporter
  # gem 'minitest-osx', require: RUBY_PLATFORM.include?('darwin') && 'minitest/osx'

  # From https://mattbrictson.com/minitest-and-rails#set-up-your-project
  # Maybe not needed but good to have the link around
  # gem 'connection_pool'
  # gem 'test_after_commit'
end

group :production do
  gem 'puma' # App server
end