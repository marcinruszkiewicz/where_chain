# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

app_path = File.expand_path('dummy', __dir__)
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)

require 'config/environment'
require 'rspec/rails'
require 'factory_bot'
require 'database_cleaner'
require 'pry'

puts "Testing Rails v#{Rails.version}"

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata schema_migrations])
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.shared_context_metadata_behavior = :apply_to_host_groups

  Kernel.srand config.seed
end
