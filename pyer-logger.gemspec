# coding: utf-8

Gem::Specification.new do |s|
  s.name          = 'pyer-logger'
  s.version       = '1.2.1'
  s.author        = 'Pierre BAZONNARD'
  s.email         = ['pierre.bazonnard@gmail.com']
  s.homepage      = 'https://github.com/pyer/pyer-logger'
  s.summary       = 'Logger'
  s.license       = 'MIT'

  s.files         = ['lib/pyer/logger.rb']
  s.executables   = []
  s.test_files    = []
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 3.0.0'

  s.add_runtime_dependency     'stringio', '~> 3.0'

  s.add_development_dependency 'rake',     '>= 13.3.0'
  s.add_development_dependency 'minitest', '= 5.4.2'
end
