$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "certify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "certify"
  s.version     = Certify::VERSION
  s.authors     = ["Dirk Eisenberg"]
  s.email       = ["dirk.eisenberg@gmail.com"]
  s.homepage    = "https://github.com/dei79/certify"
  s.summary     = "Certify is a Ruby on Rails / OpenSSL based CA engine which can be mounted in every rails application of your choice!"
  s.description = "Certify is a Ruby on Rails / OpenSSL based CA engine which can be mounted in every rails application of your choice!"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
