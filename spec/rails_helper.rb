# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'combustion'
Combustion.initialize! :active_record

require 'rspec/rails'
require 'factory_bot'
require 'pry'

puts "Testing Rails v#{Rails.version}"

Rails.backtrace_cleaner.remove_silencers!

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

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.use_transactional_fixtures = true

  Kernel.srand config.seed
end
