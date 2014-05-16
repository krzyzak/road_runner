module RoadRunner
  module Reporters
    class Classic
      attr_reader :exceptions

      def initialize(monitor: monitor)
        @monitor = monitor
        @exceptions = []
      end

      def report
        puts "\n Test suite report"
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
      def print_results_sorted_by_time(results)
        results.sort_by{|_, v| v }.reverse.each do |key, time|
          puts "#{key} took #{time}"
        end
      end
    end
  end
end
