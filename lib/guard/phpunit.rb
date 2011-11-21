require 'guard'
require 'guard/guard'

module Guard

  class PHPUnit < Guard

    autoload :Inspector, 'guard/phpunit/inspector'
    autoload :Formatter, 'guard/phpunit/formatter'
    autoload :Runner,    'guard/phpunit/runner'

    DEFAULT_OPTIONS = {
      :all_on_start => true,
      :tests_path   => Dir.pwd
    }

    def initialize(watchers = [], options = {})
      defaults = DEFAULT_OPTIONS.clone
      @options = defaults.merge(options)
      super(watchers, @options)
      Inspector.tests_path = @options[:tests_path]
    end

    def start
      run_all if options[:all_on_start]
    end

    def run_all
      success = Runner.run(options[:tests_path], options.merge(
        :message => 'Running all tests'
      ))
      throw :task_has_failed unless success
    end

    def run_on_change(paths)
      success = Runner.run(paths, options)
      throw :task_has_failed unless success   
    end
  end
end
