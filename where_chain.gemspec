# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'where_chain/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'where_chain'
  s.version     = WhereChain::VERSION
  s.authors     = ['Marcin Ruszkiewicz']
  s.email       = ['marcin.ruszkiewicz@polcode.net']
  s.homepage    = 'https://github.com/marcinruszkiewicz/where_chain'
  s.summary     = 'WhereChain extensions - Model.where.lt(created_at: Date.today)'
  s.license     = 'MIT'
  s.description = <<~DESC
    This is a Rails plugin that extends Active Record with additional methods: .like, .unlike,
    .gt, .gte, .lt and .lte, so that you can replace the SQL strings like
    Post.where('comments > 5') with Post.where.gt(comments: 5)
  DESC

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'activerecord', '>= 4.2'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
end
