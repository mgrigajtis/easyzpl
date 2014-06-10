# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easyzpl/version'

Gem::Specification.new do |spec|
  spec.name          = 'easyzpl'
  spec.version       = Easyzpl::VERSION
  spec.authors       = ['Matthew Grigajtis']
  spec.email         = ['matthew.grigajtis@gmail.com']
  spec.summary       = %q(Makes it easy to write ZPL & ZPL2.)
  spec.description   = %q(This Gem is a wrapper for the ZPL and ZPL 2 languages that are used to build labels for Zebra printers.)
  spec.homepage      = 'https://github.com/mgrigajtis/easyzpl'
  spec.license       = 'GPL'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r(^bin/)) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r(^(test|spec|features)/))
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
