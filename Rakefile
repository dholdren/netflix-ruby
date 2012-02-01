require 'rake/testtask'
require 'rubygems/package_task'

Rake::TestTask.new("test:unit") { |t|
  t.libs << 'test'
  t.test_files = Dir.glob( "test/*_test.rb" ).sort

  t.verbose = true
  t.warning = true
}
require File.join(File.dirname(__FILE__), 'test/integration/rake_test_helper')

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

gem_spec = Gem::Specification.new do |s|
  s.name = "netflix"
  s.version = "0.1.1"
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
  
  s.add_dependency("oauth")
  s.add_dependency("json")
  s.add_dependency("launchy")
  s.add_development_dependency("fakeweb")
  s.add_development_dependency("yaml")
end

Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = true
end
