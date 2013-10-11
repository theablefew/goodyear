# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goodyear/version'

Gem::Specification.new do |spec|
  spec.name          = "goodyear"
  spec.version       = Goodyear::VERSION
  spec.authors       = ["Spencer Markowski"]
  spec.email         = ["spencer@theablefew.com"]
  spec.description   = %q{ActiveRecord-like query interface for tire}
  spec.summary       = %q{ActiveRecord-like query interface for tire}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
