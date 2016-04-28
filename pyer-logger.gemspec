# coding: utf-8

Gem::Specification.new do |s|
  s.name          = 'pyer-logger'
  s.version       = '1.0.0'
  s.author        = 'Pierre BAZONNARD'
  s.email         = ['pierre.bazonnard@gmail.com']
  s.homepage      = 'https://github.com/pyer/logger'
  s.summary       = 'Logger'
  s.license       = 'MIT'

  s.files         = ['lib/pyer/logger.rb']
  s.executables   = []
  s.test_files    = []
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.1.0'

  s.add_development_dependency 'rake',     '~> 0'
  s.add_development_dependency 'minitest', '= 5.4.2'
end
