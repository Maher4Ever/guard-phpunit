module Guard
  class PHPUnit
    module Formatter
      class << self

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

        def notify(test_results)
          ::Guard::Notifier.notify(notifier_message(test_results), {
            :title => 'PHPUnit results',
            :image => notifier_image(test_results)
          })
        end

        private

        def look_for_words_in(strings_list, text)
          count = 0
          strings_list = Array(strings_list)
          strings_list.each do |s|
            text =~ %r{
              (\d)+   # count of what we are looking for 
              [ ]     # then a space
              #{s}s?  # then the string 
              .*      # then whatever
              \Z      # start looking at the end of the text
            }x
            count += $1.to_i unless $1.nil?
          end
          count
        end

        def look_for_duration_in(text)
          text =~ %r{Finished in (\d)+ seconds?.*\Z}m
          $1.nil? ? 0 : $1.to_i
        end

        def notifier_message(results)
          message = "#{results[:tests]} tests, #{results[:failures]} failures"
          message << "\n#{results[:errors]} errors"    if results[:errors]  > 0
          message << " (#{results[:pending]} pending)" if results[:pending] > 0
          message << "\nin #{results[:duration]} seconds"
          message
        end

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
