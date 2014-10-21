$:.push File.expand_path('../lib', __FILE__)
require 'crashbreak/version'

Gem::Specification.new do |spec|
  spec.name          = 'crashbreak'
  spec.version       = Crashbreak::VERSION
  spec.authors       = ['Michal Janeczek']
  spec.email         = ['michal.janeczek@ymail.com']
  spec.summary       = %q{Take a break from crashes!}
  spec.description   = %q{Maybe later... :)}
  spec.homepage      = 'crashbreak.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
