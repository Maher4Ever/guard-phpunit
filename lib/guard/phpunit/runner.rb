require 'tmpdir'
require 'fileutils'

module Guard
  class PHPUnit
    module Runner
      class << self

        def run(paths, options = {})
          paths = Array(paths)
          return false if paths.empty?

          notify_start(paths, options)
          output  = run_tests(paths, options)

          # return false in case the system call fail with no status!
          return false if $?.nil?

          if $?.success?
            notify_results(output, options)
          else
            notify_failure(options) 
          end

          $?.success?
        end

        private

        # Generates a start testing notification.
        #
        # @param [Array<String>] paths the paths to be testsed
        # @param [Hash] options the options for the execution
        #
        def notify_start(paths, options)
          message = options[:message] || "Running: #{paths.join(' ')}"
          UI.info(message, :reset => true)
        end

        def run_tests(paths, options)
          if paths.length == 1
            tests_path = paths.first
            output = system(phpunit_command(tests_path, options))
          else
            create_tests_folder_for(paths) do |tests_folder|
              output = system(phpunit_command(tests_folder, options))
            end
          end
          output
        end

        def notify_results(output, options)
          return if options[:notification] == false
          results = Formatter.parse_output(output)
          Formatter.notify(results)
        end

        def notify_failure(options)
          return if options[:notification] == false
          ::Guard::Notifier.notify('Failed! Check the console', :title => 'PHPUnit results', :image => :failed)
        end

        def create_tests_folder_for(paths)
          Dir.mktmpdir('guard_phpunit') do |d|
            symlink_paths_to_tests_folder(paths, d)
            yield d
          end
        end

        def symlink_paths_to_tests_folder(paths, folder)
          paths.each do |p|
            FileUtils.mkdir_p( File.join(folder, File.dirname(p) ) ) unless File.dirname(p) == '.'
            FileUtils.ln_s(Pathname.new(p).realpath, File.join(folder, p))
          end
        end

        def phpunit_command(path, options)
          formatter_path = File.join( File.dirname(__FILE__), 'formatters', 'PHPUnit-Progress')

          cmd_parts = []
          cmd_parts << "phpunit"
          cmd_parts << "--include-path #{formatter_path}"
          cmd_parts << "--printer PHPUnit_Extensions_Progress_ResultPrinter"
          cmd_parts << options[:cli] if options[:cli]
          cmd_parts << path

          cmd_parts.join(' ')
        end
      end
    end
  end
end
