module Guard
  class PHPUnit

    # The Guard::PHPUnit formatter parses the output
    # of phpunit which gets printed by the progress
    # printer and formats the parsed results 
    # for the notifier.
    #
    module Formatter
      class << self

        # Parses the tests output.
        #
        # @param [String] text the output of phpunit.
        # @return [Hash] the parsed results
        #
        def parse_output(text)
          results = {
            :tests    => look_for_words_in('test',    text),
            :failures => look_for_words_in('failure', text),
            :errors   => look_for_words_in('error', text),
            :pending  => look_for_words_in(['skipped', 'incomplete'], text),
            :duration => look_for_duration_in(text)
          }
          results.freeze
        end

        # Outputs a system notification.
        #
        # @param [Hash] test_results the parsed tests results
        # @option test_results [Integer] :tests tests count
        # @option test_results [Integer] :failures failures count
        # @option test_results [Integer] :errors count count
        # @option test_results [Integer] :pending pending tests count
        # @option test_results [Integer] :duration tests duration
        #
        def notify(test_results)
          ::Guard::Notifier.notify(notifier_message(test_results), {
            :title => 'PHPUnit results',
            :image => notifier_image(test_results)
          })
        end

        private

        # Searches for a list of strings in the tests output
        # and returns the total number assigned to these strings.
        #
        # @param [String, Array<String>] string_list the words
        # @param [String] text the tests output
        # @return [Integer] the total number assigned to the words 
        #
        def look_for_words_in(strings_list, text)
          count = 0
          strings_list = Array(strings_list)
          strings_list.each do |s|
            text =~ %r{
              (\d+)   # count of what we are looking for 
              [ ]     # then a space
              #{s}s?  # then the string 
              .*      # then whatever
              \Z      # start looking at the end of the text
            }x
            count += $1.to_i unless $1.nil?
          end
          count
        end

        # Searches for the duration in the tests output
        #
        # @param [String] text the tests output
        # @return [Integer] the duration
        # 
        def look_for_duration_in(text)
          text =~ %r{Finished in (\d)+ seconds?.*\Z}m
          $1.nil? ? 0 : $1.to_i
        end

        # Formats the message for the Notifier.
        # 
        # @param (see .notify)
        # @return [String] the message
        #
        def notifier_message(results)
          message = "#{results[:tests]} tests, #{results[:failures]} failures"
          message << "\n#{results[:errors]} errors"    if results[:errors]  > 0
          message << " (#{results[:pending]} pending)" if results[:pending] > 0
          message << "\nin #{results[:duration]} seconds"
          message
        end

        # Returns the appropriate image for the tests results
        # 
        # @param (see .notify)
        # @return [Symbol] the image symbol
        #
        def notifier_image(results)
          case
          when results[:failures] + results[:errors] > 0
            :failed
          when results[:pending] > 0
            :pending
          else
            :success
          end
        end
      end
    end
  end
end
