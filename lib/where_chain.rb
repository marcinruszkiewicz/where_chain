require 'active_record/where_chain_shared_methods'

if ActiveRecord::VERSION::MAJOR == 4
  require 'active_record/where_chain_extensions_rails4'
elsif ActiveRecord::VERSION::MAJOR == 5
  require 'active_record/where_chain_extensions_rails5'
end