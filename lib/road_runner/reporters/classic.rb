module RoadRunner
  module Reporters
    class Classic
      attr_reader :exceptions

      def initialize(monitor: monitor)
        @monitor = monitor
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
        exceptions.each do |exception|
          puts exception.location
        end

        puts "Slowest suites:"
        print_results_sorted_by_time(@monitor.suites)

        puts "Slowest methods:"
        print_results_sorted_by_time(@monitor.tests)
      end

      def fail(exception)
        @exceptions << exception
      end

      private
      def banner
        puts "\nFinished in 4.65 seconds"
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
