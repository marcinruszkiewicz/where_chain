# frozen_string_literal: true

require_relative 'boot'

# Pick the frameworks you want:
require 'rails/all'

Bundler.require(*Rails.groups)
require 'where_chain'

module Dummy
  class Application < Rails::Application
    config.api_only = true

    # config.assets.enabled = false
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
