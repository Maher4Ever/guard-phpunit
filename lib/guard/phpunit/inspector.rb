module Guard
  class PHPUnit

    module Inspector
      class << self

        def tests_path=(path)
          @tests_path = Array(path)
        end

        def tests_path
          @tests_path
        end
        
        def clean(paths)
          paths.uniq!
          paths.compact!
          paths = paths.select { |p| test_file?(p) }
          clear_tests_files_list
          paths
        end

        private

        def test_file?(path)
          tests_files.include?(path)
        end

        def tests_files
          @tests_files ||= Dir.glob( File.join(tests_path, '**', '*Test.php') )
        end
        
        def clear_tests_files_list
          @tests_files = nil
        end
      end
    end
  end
end
