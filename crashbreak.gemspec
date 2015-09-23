$:.push File.expand_path('../lib', __FILE__)
require 'crashbreak/version'

Gem::Specification.new do |spec|
  spec.name          = 'crashbreak'
  spec.version       = Crashbreak::VERSION
  spec.authors       = ['Michal Janeczek']
  spec.email         = ['michal.janeczek@ymail.com']
  spec.summary       = %q{Reproduce exceptions as failing tests}
  spec.description   = %q{Reproduce exceptions as failing tests}
  spec.homepage      = 'http://crashbreak.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'deepstruct'
  spec.add_development_dependency 'generator_spec'

  spec.add_runtime_dependency 'faraday', '>= 0'
  spec.add_runtime_dependency 'request_store', '>= 0'
  spec.add_runtime_dependency 'octokit', '>= 0'
  spec.add_runtime_dependency 'aws-sdk', '~> 2'
end
