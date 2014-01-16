# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic/thor/version'

Gem::Specification.new do |spec|
  spec.name          = "newrelic-thor"
  spec.version       = Newrelic::Thor::VERSION
  spec.authors       = ["Ryan Sonnek"]
  spec.email         = ["ryan@codecrate.com"]
  spec.description   = %q{NewRelic instrumentation to Thor tasks}
  spec.summary       = %q{Introspect performance of Thor tasks with NewRelic performance monitoring}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'newrelic_rpm', '>= 3.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
