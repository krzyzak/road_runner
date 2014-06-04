module RoadRunner
  module Reporters
    class Classic
      attr_reader :exceptions, :failures, :monitor

      def initialize(monitor: monitor)
        @monitor = monitor
        @failures = []
        @exceptions = []
        @tests = 0
      end

      def report_seed_value(random)
        puts "Initialized with #{random.seed}"
      end

      def increment_tests_count!
        @tests += 1
      end

      def report
        banner

        failures.each do |failure|
          puts failure.location
          # puts failure.backtrace
        end

        puts "\n Exceptions: \n"
        exceptions.each do |exception|
          puts exception#.backtrace
        end

        # puts "Slowest test_cases:"
        # print_results_sorted_by_time(@monitor.test_cases)

        # puts "Slowest methods:"
        # print_results_sorted_by_time(@monitor.tests)
      end

      def fail(failure)
        @failures << failure
      end

      def error(exception)
        @exceptions << exception
      end

      private
      def banner
        puts "\nFinished in #{monitor.total_execution_time} seconds"
        puts "#{@tests} examples, #{failed_tests_size} failures"
        puts "Failed Examples:\n"
      end

      def failed_tests_size
        exceptions.size
      end

      def print_results_sorted_by_time(results)
        results.sort_by{|_, v| v }.reverse.each do |key, time|
          puts "#{key} took #{time}"
        end
      end
    end
  end
end
