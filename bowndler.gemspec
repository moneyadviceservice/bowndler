# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bowndler/version'

Gem::Specification.new do |spec|
  spec.name          = "bowndler"
  spec.version       = Bowndler::VERSION
  spec.authors       = ["Money Advice Service", "Gareth Visagie"]
  spec.email         = ["development.team@moneyadviceservice.org.uk", "gareth@gjvis.com"]
  spec.description   = %q{Integrate bower and bundler, by making bower aware of gem bundles.}
  spec.summary       = %q{Integrate bower and bundler, by making bower aware of gem bundles.}
  spec.homepage      = "https://github.com/moneyadviceservice/bowndler"
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
