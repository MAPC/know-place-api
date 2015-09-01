require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KnowPlaceApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # In production, only the client should be able to POST data to the server.
    # Set the KNOWN_HOSTS environment variable to '*' in the development and staging environments.
    # to allow any host to connect to it. In production, set it to a comma-separated list of
    # domains where the client application is known to be hosted.
    # # => KNOWN_HOSTS=clientside.knowplace.com,another.pla.ce
    KNOWN_HOSTS = ENV.fetch('KNOWN_HOSTS') { 'todo.productionsi.te' }
    DEBUG_CORS  = ENV.fetch('DEBUG_CORS')  { false }

    config.middleware.insert_before 0, "Rack::Cors", debug: DEBUG_CORS, logger: (-> { Rails.logger }) do
      allow do
        origins  KNOWN_HOSTS.split(',')
        resource '*', headers: :any, methods: [:get, :post, :put, :patch]
      end
    end

  end
end
