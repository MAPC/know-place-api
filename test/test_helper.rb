ENV["RAILS_ENV"] = "test"
if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
# require "minitest/osx" # Uses terminal-reporter, which hangs.
require "minitest/hell" # Random ordering
require "minitest/benchmark" if ENV["BENCH"]

# Require entire support tree
Dir[File.expand_path("test/support/**/*")].each { |file| require file }

# Improved Minitest output (color and progress bar)
require "minitest/reporters"
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

# Awesome colorful output
require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end