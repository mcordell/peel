# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peel/version'

Gem::Specification.new do |spec|
  spec.name          = "peel"
  spec.version       = Peel::VERSION
  spec.authors       = ["Michael Cordell"]
  spec.email         = ["surpher@gmail.com"]
  spec.description   = %q{Token authentication for Grape APIs with warden.}
  spec.summary       = %q{Token authentication for Grape APIs with warden.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "grape"
  spec.add_dependency "jwt"
  spec.add_dependency "warden"
  spec.add_dependency "bcrypt"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
