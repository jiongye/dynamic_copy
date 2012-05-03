$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dynamic_copy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dynamic_copy"
  s.version     = DynamicCopy::VERSION
  s.authors     = ["Jiongye Li"]
  s.email       = ["jiongye@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "An I18n backend with key-value store using Redis"
  s.description = "Use Redis to store all locale, and provide an admin to manage locale and translations"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.1.0"
  # s.add_dependency "jquery-rails"
  s.add_dependency "redis"


  s.add_development_dependency "rspec-rails"

end
