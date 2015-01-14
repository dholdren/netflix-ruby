# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'netflix/version'

Gem::Specification.new do |s|
  s.name = "netflix"
  s.version = Netflix::VERSION
  s.authors = ["Dean Holdren"]
  s.date = %q{2012-01-09}
  s.description = "Ruby Netflix API wrapper"
  s.summary = s.description
  s.email = 'deanholdren@gmail.com'
  
  s.require_path = "lib"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  
  s.homepage = "https://github.com/dholdren/netflix-ruby"
  s.has_rdoc = false
  
  s.add_dependency "oauth", "~> 0.4"
  s.add_dependency "json",  "~> 1.7"
  s.add_dependency "launchy", "~> 2.1"

  s.add_development_dependency "fakeweb", "~> 1.3"
end

