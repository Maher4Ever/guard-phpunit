module Guard
  class PHPUnit

    # The Guard::PHPUnit inspector verfies that the changed paths
    # are valid for Guard::PHPUnit.
    #
    module Inspector
      class << self

        attr_accessor :tests_path

        # Clean the changed paths and return only valid
        # PHPUnit tests files.
        #
        # @param [Array<String>] paths the changed paths
        # @return [Array<String>] the valid tests files
        #
        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| test_file?(p) }
          clear_tests_files_list
          paths
        end

        private

        # Checks if the paths is a valid test file.
        #
        # @param [String] path the test path
        # @return [Boolean] whether the path a valid test or not
        #
        def test_file?(path)
          tests_files.include?(path)
        end

        # Scans the tests path and keeps a list of all
        # tests paths.
        #
        def tests_files
          @tests_files ||= Dir.glob( File.join(tests_path, '**', '*Test.php') )
        end

        # Clears the list of PHPUnit tests.
        #
        # @see #clean
        #
        def clear_tests_files_list
          @tests_files = nil
        end
      end
    end
  end
end
