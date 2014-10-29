# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qualtrics/version'

Gem::Specification.new do |spec|
  spec.name          = 'qualtrics'
  spec.version       = Qualtrics::VERSION
  spec.authors       = ['College of Engineering']
  spec.email         = ['kildow.5']
  spec.summary       = %q{Qualtrics ruby gem.}
  spec.description   = %q{Qualtrics ruby gem. Interacts with qualtrics through web services.}
  spec.homepage      = 'https://code.osu.edu/ews/qualtrics'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'nokogiri', '~> 1.6.3'
  spec.add_dependency 'ruby-mcrypt', '~> 0.2.0'
  spec.add_dependency 'faraday', '~> 0.9.0'
end
