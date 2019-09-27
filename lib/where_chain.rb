# frozen_string_literal: true

require 'active_record/where_chain_shared_methods'

# Active Record changed a lot in Rails 5 and 4 is still supported
if ActiveRecord::VERSION::MAJOR == 4
  require 'active_record/where_chain_extensions_rails4'
elsif ActiveRecord::VERSION::MAJOR == 5 || ActiveRecord::VERSION::MAJOR == 6
  require 'active_record/where_chain_extensions_rails5'
end
