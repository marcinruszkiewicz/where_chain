# frozen_string_literal: true

require 'active_record/where_chain_shared_methods'

# Active Record changed a lot in Rails 5 and 4 is still supported
case ActiveRecord::VERSION::MAJOR
when 4
  require 'active_record/where_chain_extensions_rails4'
when 5, 6, 7
  require 'active_record/where_chain_extensions_rails5'
end
