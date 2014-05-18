module RoadRunner
  module Reporters
    class Classic
      attr_reader :exceptions

      def initialize
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
    end
  end
end
