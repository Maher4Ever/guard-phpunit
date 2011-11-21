source "http://rubygems.org"

# Specify your gem's dependencies in guard-phpunit.gemspec
gemspec

gem 'rake'

require 'rbconfig'

platforms :ruby do
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.4.0'
    gem 'growl',      '~> 1.0.3'
  end
  if RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.8.8'
    gem 'libnotify',  '~> 0.5.9'
  end
end

platforms :jruby do
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'growl',      '~> 1.0.3'
  end
  if RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.8.8'
    gem 'libnotify',  '~> 0.5.9'
  end
end
