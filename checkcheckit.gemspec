# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checkcheckit/version'

Gem::Specification.new do |gem|
  gem.name          = "checkcheckit"
  gem.version       = CheckCheckIt::VERSION
  gem.authors       = ["Chris Continanza"]
  gem.email         = ["christopher.continanza@gmail.com"]
  gem.description   = %q{Checklists like a boss}
  gem.summary       = %q{Command line tool for using checklists}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = 'check'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'lucy-goosey', '~> 0.2.0'
  gem.add_dependency 'excon'
  gem.add_dependency 'yajl-ruby'
  gem.add_dependency 'colored'
end
