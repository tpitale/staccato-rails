# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'staccato-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "staccato-rails"
  spec.version       = StaccatoRails::VERSION
  spec.authors       = ["Tony Pitale"]
  spec.email         = ["tpitale@gmail.com"]
  spec.description   = "Rails integration with Staccato for Google Analytics measurement."
  spec.summary       = "Rails integration with Staccato for Google Analytics measurement."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "staccato"
end
