$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "where_chain/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "where_chain"
  s.version     = WhereChain::VERSION
  s.authors     = ["Marcin Ruszkiewicz"]
  s.email       = ["marcin.ruszkiewicz@polcode.net"]
  s.homepage    = "https://github.com/marcinruszkiewicz"
  s.summary     = "WhereChain extensions - Model.where.lt(created_at: Date.today)"
  s.description = "WhereChain is a Rails plugin that provides extensions for ActiveRecord. Since Rails 4 you can do Model.where.not(name: 'Bad') and this module adds "
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activerecord", ">= 4.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "appraisal" 
  s.add_development_dependency "database_cleaner"
end
