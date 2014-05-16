module RoadRunner
  module Reporters
    class Classic
      attr_reader :exceptions

      def initialize
        @exceptions = []
      end

      def report
        puts "\n Test suite report"
        exceptions.each do |exception|
          puts exception.location
        end
      end

      def fail(exception)
        @exceptions << exception
      end
    end
  end
end
