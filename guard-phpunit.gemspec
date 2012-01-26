# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'guard/phpunit/version'

Gem::Specification.new do |s|
  s.name        = "guard-phpunit"
  s.version     = Guard::PHPUnitVersion::VERSION
  s.authors     = ["Maher Sallam"]
  s.email       = ["maher@sallam.me"]
  s.homepage    = ""
  s.summary     = %q{Guard gem for PHPUnit}
  s.description = %q{Guard::PHPUnit automatically run your unit-tests written with the PHPUnit testing framework.}

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = 'guard-phpunit'

  s.add_runtime_dependency 'guard', '~> 1.0.0'

  s.add_development_dependency 'bundler',     '~> 1.0.21'
  s.add_development_dependency 'rspec',       '~> 2.8.0'
  s.add_development_dependency 'guard-rspec', '~> 0.6.0'
  s.add_development_dependency 'yard',        '~> 0.7.4'
  s.add_development_dependency 'redcarpet',   '~> 2.1.0'

  s.files         = `git ls-files -- lib/*`.split("\n") + Dir.glob('{lib}/**/PHPUnit/**/*') + %w[LICENSE README.md]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
