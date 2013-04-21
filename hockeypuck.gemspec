# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hockeypuck/version"

Gem::Specification.new do |s|
  s.name        = "hockeypuck"
  s.version     = Hockeypuck::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gazay']
  s.email       = ['alex.gaziev@gmail.com']
  s.homepage    = "https://github.com/gazay/hockeypuck"
  s.summary     = %q{Fetch all what you want from web fast and threaded}
  s.description = %q{Smart multithreading download manager for fetching data from cli, and from ruby code}

  s.rubyforge_project = "hockeypuck"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
