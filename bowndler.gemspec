# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bowndler/version'

Gem::Specification.new do |spec|
  spec.name          = "bowndler"
  spec.version       = Bowndler::VERSION
  spec.authors       = ["Gareth Visagie"]
  spec.email         = ["gareth@gjvis.com"]
  spec.description   = %q{Bowndler}
  spec.summary       = %q{Bowndler}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
