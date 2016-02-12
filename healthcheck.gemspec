$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "healthcheck/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "healthcheck"
  s.version     = Healthcheck::VERSION
  s.authors     = ["Fernando Ferreira Chucre"]
  s.email       = ["Iventis.fernando@valepresente.com.br"]
  s.homepage    = "https://stash.valepresente.net.br/projects/LIBS/repos/gem-healthcheck/"
  s.summary     = "Add healthcheck to a rails app"
  s.description = "Add healthcheck to a rails app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.1"
  s.add_dependency "ruby-graphviz", ">= 1.2.2"

  s.add_development_dependency "sqlite3"
end
