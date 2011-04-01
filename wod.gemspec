# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wod/version"

Gem::Specification.new do |s|
  s.name        = "wod"
  s.version     = Wod::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dave Newman"]
  s.email       = ["dave@whatupdave.com"]
  s.homepage    = "http://github.com/snappycode/wod"
  s.summary     = %q{The Wizard Of Dev center}
  s.description = %q{Command line tool for interacting with the Apple Dev Center}

  s.rubyforge_project = "wod"
  
  s.add_dependency "mechanize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
