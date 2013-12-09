$:.push File.expand_path("../lib", __FILE__)
require "rubyhorn/version"
Gem::Specification.new do |s|
  s.name = "rubyhorn"
  s.version = Rubyhorn::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Chris Colvard"]
  s.email = ["cjcolvar@indiana.edu"]
  s.summary = %q{Opencast Matterhorn REST API ruby library }
  s.description = %q{Opencast Matterhorn REST API ruby library : REQUIRES Matterhorn 1.2+}
  s.homepage = "http://github.com/avalonmediasystem/rubyhorn"
  s.license = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

#  s.add_dependency "nokogiri"
  s.add_dependency "mime-types"
  s.add_dependency "activesupport"
#  s.add_dependency "activemodel"
  s.add_dependency "json"
  s.add_dependency "net-http-digest_auth"
  s.add_dependency "om"
  s.add_dependency "rest-client"

  s.add_development_dependency("rake")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("bundler", ">= 1.0.14")
  s.add_development_dependency("rspec")
  s.add_development_dependency("yard")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("rspec_junit_formatter")
end
