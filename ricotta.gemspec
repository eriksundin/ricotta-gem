# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ricotta"

Gem::Specification.new do |s|
  s.name        = "ricotta"
  s.authors     = ["Erik Sundin"]
  s.email       = "erik@eriksundin.se"
  s.homepage    = "http://github.com/eriksundin/ricotta"
  s.version     = Ricotta::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Ricotta"
  s.description = "Tool for downloading translations from Ricotta"

  s.add_development_dependency "rspec", "~> 0.6.1"
  s.add_development_dependency "rake",  "~> 0.9.2"

  s.add_dependency "commander", "~> 4.1.2"
  s.add_dependency "faraday", "~> 0.8.0"
  s.add_dependency "faraday_middleware", "~> 0.9.0"

  s.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
