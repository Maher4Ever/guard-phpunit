require 'guard'
require 'guard/guard'

module Guard

  # The PHPUnit guard gets notified about system 
  # events.
  #
  class PHPUnit < Guard

    autoload :Inspector, 'guard/phpunit/inspector'
    autoload :Formatter, 'guard/phpunit/formatter'
    autoload :Notifier,  'guard/phpunit/notifier'
    autoload :Runner,    'guard/phpunit/runner'

    DEFAULT_OPTIONS = {
      :all_on_start => true,
      :keep_failed  => true,
      :cli          => nil,
      :tests_path   => Dir.pwd
    }

    # Initialize Guard::PHPUnit.
    #
    # @param [Array<Guard::Watcher>] watchers the watchers in the Guard block
    # @param [Hash] options the options for the Guard
    # @option options [Boolean] :all_on_start run all tests on start
    # @option options [String] :cli The CLI arguments passed to phpunit
    # @option options [String] :tests_path the path where all tests exist
    #
    def initialize(watchers = [], options = {})
      defaults = DEFAULT_OPTIONS.clone
      @options = defaults.merge(options)
      super(watchers, @options)

      @failed_paths = []

      Inspector.tests_path = @options[:tests_path]
    end

    # Gets called once when Guard starts.
    #
    # @raise [:task_has_failed] when stop has failed
    #
    def start
      run_all if options[:all_on_start]
    end

    # Gets called when all tests should be run.
    #
    # @raise (see #start)
    #
    def run_all
      success = Runner.run(options[:tests_path], options.merge(
        :message => 'Running all tests'
      ))
      throw :task_has_failed unless success
    end

    # Gets called when the watched tests have changes.
    #
    # @param [Array<String>] paths to the changed tests
    # @raise (see #start)
    #
    def run_on_change(paths)
      paths = Inspector.clean(paths + @failed_paths)
      success = Runner.run(paths, options)

      if success 
        @failed_paths -= paths if @options[:keep_failed]
      else
        @failed_paths += paths if @options[:keep_failed]
      end

      throw :task_has_failed unless success
    end
  end
end
