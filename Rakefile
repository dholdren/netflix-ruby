# -*- encoding: utf-8 -*-
require 'rake/testtask'
require File.join(File.dirname(__FILE__), 'test/integration/rake_test_helper')
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

task :default => [:test]

Rake::TestTask.new("test:unit") { |t|
  t.libs << 'test'
  t.test_files = Dir.glob( "test/lib/*_test.rb" ).sort

  t.verbose = false
  t.warning = false
}

file "test/integration/oauth_settings.yml" do |t|
  credentials = IntegrationTestHelper.obtain_credentials
  open("test/integration/oauth_settings.yml", 'wb') do |f|
    YAML.dump(credentials, f)
  end
end

Rake::TestTask.new("test:integration") { |t|
  #t.description = "Run integration tests against a REAL netflix account you supply"
  t.libs << 'test'
  t.test_files = Dir.glob( "test/integration/**/*_test.rb" ).sort

  t.verbose = true
  t.warning = true
}

task "test:integration" => "test/integration/oauth_settings.yml"

desc "run unit tests only"
task :test => "test:unit"

# Gem tasks
require "netflix/version"
 
task :build do
  system "gem build .gemspec"
end
 
task :release => :build do
  system "gem push bundler-#{Netflix::VERSION}"
end

