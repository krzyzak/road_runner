module RoadRunner
  module Formatters
    class Classic
      def success
        print "."
      end

      def fail
        print "F"
      end

      def skip
        print "S"
      end

      def error
        print "E"
      end
    end
  end
end
